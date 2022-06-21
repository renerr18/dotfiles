
if [ "$CODESPACES" != "true" ]; then 
  alias aws-lp="aws_login login production"
  alias aws-lp-tf="aws_login login production --role=terraform-backend-access --duration=3600"
  alias aws-ls="aws_login login staging"
  alias aws-ls-tf="aws_login login staging --role=terraform-backend-access --duration=3600"
  alias aws-la="aws_login login alpha"
  alias aws-lb="aws_login login bravo"
  alias aws-lc="aws_login login charlie"
  alias aws-lpa="aws_login login papa"

  function aws-ecr-login() {
    repo=$1
    accountid=$(aws sts get-caller-identity --query Account --output text)
    ecrurl="${accountid}.dkr.ecr.us-east-1.amazonaws.com/${repo}"
    aws ecr get-login-password --region 'us-east-1' \
    | docker login \
    --username AWS \
    --password-stdin \
    $ecrurl
  }


  # AWS
  function dk-aws() {
    AWS_PROFILE=${AWS_PROFILE:=default}
    AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:=us-east-1}
    docker run \
      --interactive \
      --rm \
      --env AWS_PROFILE=$AWS_PROFILE \
      --env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
      --env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
      --env AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
      --env AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
      --volume "${HOME}/.kube:/root/.kube:delegated" \
      --volume "${HOME}/.aws:/root/.aws:delegated" \
      --volume "${HOME}/Desktop:/root/Desktop" \
      --volume "/tmp:/tmp" \
      --volume "${PWD}:/aws:delegated" \
      "amazon/aws-cli:2.0.6" \
      $@
  }
fi
