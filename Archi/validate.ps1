# Script de validation pour l'architecture Hub and Spoke
Write-Host "🔍 Validation de l'architecture Hub and Spoke..." -ForegroundColor Green

# Vérifier que Terraform est installé
Write-Host "📋 Vérification de Terraform..." -ForegroundColor Yellow
if (Get-Command terraform -ErrorAction SilentlyContinue) {
    $tfVersion = terraform version
    Write-Host "✅ Terraform trouvé: $($tfVersion.Split("`n")[0])" -ForegroundColor Green
} else {
    Write-Host "❌ Terraform non trouvé. Veuillez l'installer." -ForegroundColor Red
    exit 1
}

# Vérifier que Azure CLI est installé et connecté
Write-Host "📋 Vérification d'Azure CLI..." -ForegroundColor Yellow
if (Get-Command az -ErrorAction SilentlyContinue) {
    $azAccount = az account show --query "name" -o tsv 2>$null
    if ($azAccount) {
        Write-Host "✅ Azure CLI connecté au compte: $azAccount" -ForegroundColor Green
    } else {
        Write-Host "❌ Azure CLI non connecté. Exécutez 'az login'" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "❌ Azure CLI non trouvé. Veuillez l'installer." -ForegroundColor Red
    exit 1
}

# Vérifier les fichiers de configuration
Write-Host "📋 Vérification des fichiers de configuration..." -ForegroundColor Yellow
$requiredFiles = @("conf.tf", "variables.tf", "terraform.tfvars", "main.tf", "outputs.tf")
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file trouvé" -ForegroundColor Green
    } else {
        Write-Host "❌ $file manquant" -ForegroundColor Red
        exit 1
    }
}

# Vérifier les modules
Write-Host "📋 Vérification des modules..." -ForegroundColor Yellow
$requiredModules = @("network", "nsg", "PublicIP", "FirewallPolicy", "Firewall", "vnetPeering", "container_apps", "appGetWay")
foreach ($module in $requiredModules) {
    if (Test-Path "modules/$module") {
        Write-Host "✅ Module $module trouvé" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Module $module manquant dans modules/" -ForegroundColor Yellow
    }
}

# Initialiser Terraform
Write-Host "📋 Initialisation de Terraform..." -ForegroundColor Yellow
terraform init

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Terraform initialisé avec succès" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur lors de l'initialisation de Terraform" -ForegroundColor Red
    exit 1
}

# Valider la configuration
Write-Host "📋 Validation de la configuration..." -ForegroundColor Yellow
terraform validate

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Configuration Terraform valide" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur de validation de la configuration" -ForegroundColor Red
    exit 1
}

# Planifier le déploiement (dry-run)
Write-Host "📋 Planification du déploiement (dry-run)..." -ForegroundColor Yellow
terraform plan -out=tfplan

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Planification réussie" -ForegroundColor Green
    Write-Host "🚀 Prêt pour le déploiement avec 'terraform apply tfplan'" -ForegroundColor Cyan
} else {
    Write-Host "❌ Erreur lors de la planification" -ForegroundColor Red
    exit 1
}

Write-Host "🎉 Validation terminée avec succès!" -ForegroundColor Green 