task :build do
  sh 'middleman build'
end

task :clean do
  rm_rf 'build'
end

task :deploy => :build do
    sh "aws s3 sync ./build s3://lunrjs.com --acl public-read --region us-east-1"
end

task default: :build
