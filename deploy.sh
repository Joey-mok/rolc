#!/bin/bash
# ROLC Website V2 Deployer
# Built by Ilyong for Boss (큰형님)

set -e

# Clear screen for readability
clear

echo "=============================================================="
echo "  🎬 ROLC Website V2 배포 자동화 스크립트 (Ilyong Deployer)"
echo "=============================================================="
echo ""
echo " 보스! 깃허브 보안 정책에 따라 패스워드 대신 토큰(classic)이 필요합니다."
echo " 토큰은 아래 주소에서 1분 만에 생성할 수 있습니다:"
echo " 👉 https://github.com/settings/tokens"
echo " (권한 범위 중 'repo' 부분에 체크가 되어 있어야 합니다!)"
echo ""
echo "--------------------------------------------------------------"

# Prompt user to input their PAT (Personal Access Token) securely
# -s hides the input characters as they type for security
read -s -p "🔑 발급받으신 깃허브 토큰(ghp_...)을 마우스 우클릭으로 붙여넣고 엔터를 치세요: " GITHUB_TOKEN
echo ""

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ 에러: 토큰 값이 입력되지 않았습니다. 다시 실행해 주세요."
    exit 1
fi

USERNAME="joey-mok"
REPO="rolc"

echo ""
echo "🔄 [1/3] 깃허브 인증 토큰을 원격 저장소에 보안 적용 중..."
# Temporary injection of token into remote URL
git remote set-url origin "https://${USERNAME}:${GITHUB_TOKEN}@github.com/${USERNAME}/${REPO}.git"

echo "🚀 [2/3] 최신 V2 웹사이트 소스를 깃허브 서버로 푸시(Push) 중..."
if git push origin main; then
    echo ""
    echo "=============================================================="
    echo "  🎉 축하합니다, 보스! ROLC Website V2가 성공적으로 배포되었습니다!"
    echo "=============================================================="
    echo "  1~2분 뒤 서버 캐시가 갱신되면 아래 도메인으로 접속해 보세요!"
    echo ""
    echo "  🌐 국문 최신 V2: http://rolc.pro/index-ko-v2.html"
    echo "  🌐 영문 최신 V2: http://rolc.pro/index-v2.html"
    echo "=============================================================="
    echo ""
else
    echo "❌ 에러: 푸시에 실패했습니다. 토큰의 'repo' 권한 체크 여부 및 입력값을 다시 확인해 주세요."
fi

echo "🔒 [3/3] 보안 강화를 위해 로컬 설정에서 인증 토큰 흔적을 안전하게 소거 중..."
# Revert remote URL back to safe default so token is never exposed in .git/config
git remote set-url origin "https://github.com/${USERNAME}/${REPO}.git"
echo "✅ 소거 완료! 개인정보가 안전하게 보호되었습니다."
echo ""
