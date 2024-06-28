#!/bin/sh

response=$(curl -s "https://api.github.com/repos/k3s-io/k3s/releases/latest")
latest_version=$(echo "$response" | grep -o '"tag_name": "[^"]*' | awk -F'": "' '{print $2}')

## Check if the latest version is already installed
## $1: IP of the node
function check_version() {
    current_version=$(ssh -o StrictHostKeyChecking=no -t ubuntu@$1 "k3s --version | cut -d ' ' -f 3 | head -n 1 | tr -d '\n'")
    if [ "$current_version" = "$latest_version" ]; then
        echo "true"
    fi
    echo "false"
}

## Function to upgrade k3s on given nodes
## $1: Role of the nodes (master, worker)
function upgrade_nodes() {
    IPs=($(kubectl get nodes -l node-role.kubernetes.io/$1 -o wide | awk 'NR>1 {print $6}'))
    NODES_NAME=($(kubectl get nodes -l node-role.kubernetes.io/$1 -o wide | awk 'NR>1 {print $1}'))
    TOKEN=$(kubectl get secret ungarscool1-k3s-upgrade -n default -o jsonpath='{.data.token}' | base64 --decode)
    for i in "${!IPs[@]}"; do
        echo "Checking if k3s is already on the latest version on ${NODES_NAME[$i]} (${IPs[$i]})"
        if [ "$(check_version ${IPs[$i]})" = "true" ]; then
            echo "k3s is already on the latest version on ${NODES_NAME[$i]} (${IPs[$i]})"
            continue
        fi
        echo "Draining ${NODES_NAME[$i]} (${IPs[$i]})"
        kubectl drain ${NODES_NAME[$i]} --ignore-daemonsets --delete-emptydir-data > /dev/null
        echo "Upgrading k3s on ${NODES_NAME[$i]} (${IPs[$i]})"
        ssh -o StrictHostKeyChecking=no -t ubuntu@${IPs[$i]} "wget https://github.com/k3s-io/k3s/releases/download/$latest_version/k3s && sudo mv -f k3s /usr/local/bin/k3s && sudo chmod +x /usr/local/bin/k3s && sudo reboot now"
        echo "Waiting the host to restart, sleeping 30s to restart checks"
        sleep 30
        while true; do
            node_status=$(curl -s -k --location "https://${IPs[$i]}:6443/readyz?verbose" --header "Authorization: Bearer $TOKEN")
            if [[ "$node_status" == *"readyz check passed"* ]]; then
                break
            fi
            echo "Waiting for k3s to come back up on ${NODES_NAME[$i]} (${IPs[$i]})"
            sleep 10
        done
        echo "Uncordoning ${NODES_NAME[$i]} (${IPs[$i]})"
        kubectl uncordon ${NODES_NAME[$i]} > /dev/null
    done
}


function create_secret() {
    kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: ungarscool1-k3s-upgrade
  namespace: default
  annotations:
    kubernetes.io/service-account.name: default
type: kubernetes.io/service-account-token
EOF
    while ! kubectl describe secret ungarscool1-k3s-upgrade -n default | grep -E '^token' >/dev/null; do
      echo "waiting for token..." >&2
      sleep 1
    done
}

function remove_secret() {
    kubectl delete secret ungarscool1-k3s-upgrade -n default
}

create_secret
upgrade_nodes "master"
upgrade_nodes "worker"
remove_secret