#!/bin/bash
# scripts/security-audit.sh
# 의존성 취약점 스캔 스크립트
#
# 사용법: bash scripts/security-audit.sh

set -e

echo "====================================="
echo "WalkDog Security Audit"
echo "====================================="
echo ""

# 1. Flutter 의존성 확인
echo "[1/3] Flutter dependencies (outdated check)..."
dart pub outdated 2>&1 || true
echo ""

# 2. npm 취약점 스캔 (Cloud Functions)
echo "[2/3] Cloud Functions npm audit..."
cd functions
npm audit 2>&1 || true
cd ..
echo ""

# 3. Flutter analyze
echo "[3/3] Flutter static analysis..."
flutter analyze 2>&1 || true
echo ""

echo "====================================="
echo "Audit complete"
echo "====================================="
