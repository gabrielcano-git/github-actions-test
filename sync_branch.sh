#!/bin/bash

# Obtém o nome da branch atual
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Define a branch de destino intermediária
TARGET_BRANCH="homol"
NEW_BRANCH="${CURRENT_BRANCH}--homol"

echo "Branch atual: $CURRENT_BRANCH"
echo "Trocando para a branch $TARGET_BRANCH..."
git checkout $TARGET_BRANCH || { echo "Erro ao mudar para $TARGET_BRANCH"; exit 1; }

echo "Criando nova branch $NEW_BRANCH a partir de $TARGET_BRANCH..."
git checkout -b $NEW_BRANCH || { echo "Erro ao criar a nova branch $NEW_BRANCH"; exit 1; }

echo "Pegando commits da branch $CURRENT_BRANCH..."
COMMITS=$(git log --format="%H" $TARGET_BRANCH..$CURRENT_BRANCH)

if [ -z "$COMMITS" ]; then
  echo "Nenhum commit encontrado para cherry-pick."
else
  for COMMIT in $COMMITS; do
    echo "Aplicando commit $COMMIT..."
    git cherry-pick $COMMIT || { echo "Erro ao aplicar commit $COMMIT"; exit 1; }
  done
fi

echo "Fazendo push da branch $NEW_BRANCH..."
git push origin $NEW_BRANCH || { echo "Erro ao fazer push"; exit 1; }

echo "Processo concluído com sucesso!"
