# basic-vpc

## 概要

基本的なVPC環境構築用Terraformモジュールです。

## 利用方法

モジュール登録先を参照  
<https://app.terraform.io/app/ryoqn-company/registry/modules/public/ryoqn-company/basic-vpc/aws/>

## 開発環境構築

### terraformのインストール

[tfenv](https://github.com/tfutils/tfenv)を使用

``` shel
tfenv install 1.2.2
tfenv use 1.2.2
```

### pre-commit-terraformのインストール

<https://pre-commit.com/>  
<https://github.com/antonbabenko/pre-commit-terraform>

pre-commitを使ったfmt,lint,validateの実行(ステージングしていないファイルも対象にするため -a オプションを付ける)

```shell
pre-commit run terraform_fmt -a
pre-commit run terraform_tflint -a
pre-commit run terraform_validate -a

# 全部実行する場合
pre-commit run -a
```
