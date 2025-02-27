env=$( echo "$1" | tr -s  '[:upper:]'  '[:lower:]' )
# accept dev, qa, stg, uat, prod, dr-test, dr
echo "environment: $env"

case $env in
    qa)
        echo $env
        ;;
    prod)
        echo $env
        ;;
    *)
        echo "Error: $env is not set correctly environment. Exiting."
        exit 1
        ;;
esac

## run the image
docker run -d --restart=always -p 8080:8080 -e spring.profiles.active=$env springdemo:latest