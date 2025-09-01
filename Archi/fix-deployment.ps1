# Script pour nettoyer et redéployer l'infrastructure Hub and Spoke
Write-Host "🧹 Nettoyage et redéploiement de l'infrastructure..." -ForegroundColor Green

# Étape 1: Détruire l'infrastructure existante
Write-Host "📋 Destruction de l'infrastructure existante..." -ForegroundColor Yellow
terraform destroy -auto-approve

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Infrastructure détruite avec succès" -ForegroundColor Green
} else {
    Write-Host "⚠️ Erreur lors de la destruction (certaines ressources peuvent ne pas exister)" -ForegroundColor Yellow
}

# Étape 2: Nettoyer l'état Terraform
Write-Host "📋 Nettoyage de l'état Terraform..." -ForegroundColor Yellow
if (Test-Path "terraform.tfstate") {
    Remove-Item "terraform.tfstate" -Force
    Write-Host "✅ État Terraform nettoyé" -ForegroundColor Green
}

if (Test-Path "terraform.tfstate.backup") {
    Remove-Item "terraform.tfstate.backup" -Force
    Write-Host "✅ Sauvegarde d'état supprimée" -ForegroundColor Green
}

# Étape 3: Réinitialiser Terraform
Write-Host "📋 Réinitialisation de Terraform..." -ForegroundColor Yellow
terraform init -reconfigure

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Terraform réinitialisé avec succès" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur lors de la réinitialisation" -ForegroundColor Red
    exit 1
}

# Étape 4: Attendre que les ressources Azure soient complètement supprimées
Write-Host "⏳ Attente de 60 secondes pour que les ressources Azure soient complètement supprimées..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

# Étape 5: Valider la configuration
Write-Host "📋 Validation de la configuration..." -ForegroundColor Yellow
terraform validate

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Configuration valide" -ForegroundColor Green
} else {
    Write-Host "❌ Configuration invalide" -ForegroundColor Red
    exit 1
}

# Étape 6: Planifier le déploiement
Write-Host "📋 Planification du nouveau déploiement..." -ForegroundColor Yellow
terraform plan -out=tfplan

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Planification réussie" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur lors de la planification" -ForegroundColor Red
    exit 1
}

# Étape 7: Déployer l'infrastructure
Write-Host "📋 Déploiement de la nouvelle infrastructure..." -ForegroundColor Yellow
terraform apply tfplan

if ($LASTEXITCODE -eq 0) {
    Write-Host "🎉 Infrastructure déployée avec succès!" -ForegroundColor Green
    Write-Host "📊 Voici les sorties importantes:" -ForegroundColor Cyan
    terraform output
} else {
    Write-Host "❌ Erreur lors du déploiement" -ForegroundColor Red
    exit 1
}

Write-Host "✨ Processus terminé!" -ForegroundColor Green 