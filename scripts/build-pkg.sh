#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
PKGROOT="${DIST_DIR}/pkgroot"
PKGSCRIPTS="${DIST_DIR}/pkgscripts"

VERSION="${1:-}"
if [[ -z "${VERSION}" ]]; then
  VERSION="$(awk -F'"' '/^TMX_VERSION=/{print $2}' "${ROOT_DIR}/bin/tmexclude")"
fi
if [[ -z "${VERSION}" ]]; then
  echo "Unable to detect version. Pass it explicitly: ./scripts/build-pkg.sh 0.3.0" >&2
  exit 1
fi

PKG_ID="com.tmexclude.cli"
PKG_NAME="tmexclude-${VERSION}.pkg"
INSTALL_PREFIX="/usr/local/lib/tmexclude"
SIGN_IDENTITY="${PKG_SIGN_IDENTITY:-}"

rm -rf "${PKGROOT}" "${PKGSCRIPTS}"
mkdir -p \
  "${PKGROOT}${INSTALL_PREFIX}" \
  "${PKGROOT}/usr/local/bin" \
  "${PKGSCRIPTS}" \
  "${DIST_DIR}"

cp -R "${ROOT_DIR}/bin" "${PKGROOT}${INSTALL_PREFIX}/bin"
cp -R "${ROOT_DIR}/lib" "${PKGROOT}${INSTALL_PREFIX}/lib"
cp "${ROOT_DIR}/install.sh" "${PKGROOT}${INSTALL_PREFIX}/install.sh"
cp "${ROOT_DIR}/uninstall.sh" "${PKGROOT}${INSTALL_PREFIX}/uninstall.sh"
cp "${ROOT_DIR}/config.example" "${PKGROOT}${INSTALL_PREFIX}/config.example"
cp "${ROOT_DIR}/config.example.yaml" "${PKGROOT}${INSTALL_PREFIX}/config.example.yaml"
cp "${ROOT_DIR}/README.md" "${PKGROOT}${INSTALL_PREFIX}/README.md"
cp "${ROOT_DIR}/LICENSE" "${PKGROOT}${INSTALL_PREFIX}/LICENSE"

cat > "${PKGROOT}/usr/local/bin/tmexclude" <<'EOF'
#!/usr/bin/env bash
exec /usr/local/lib/tmexclude/bin/tmexclude "$@"
EOF

chmod +x \
  "${PKGROOT}/usr/local/bin/tmexclude" \
  "${PKGROOT}${INSTALL_PREFIX}/bin/tmexclude" \
  "${PKGROOT}${INSTALL_PREFIX}/install.sh" \
  "${PKGROOT}${INSTALL_PREFIX}/uninstall.sh"

cp "${ROOT_DIR}/packaging/postinstall" "${PKGSCRIPTS}/postinstall"
chmod +x "${PKGSCRIPTS}/postinstall"

PKGBUILD_ARGS=(
  --root "${PKGROOT}"
  --scripts "${PKGSCRIPTS}"
  --identifier "${PKG_ID}"
  --version "${VERSION}"
  --install-location "/"
)

if [[ -n "${SIGN_IDENTITY}" ]]; then
  PKGBUILD_ARGS+=(--sign "${SIGN_IDENTITY}")
fi

pkgbuild "${PKGBUILD_ARGS[@]}" "${DIST_DIR}/${PKG_NAME}"

echo "Built package: ${DIST_DIR}/${PKG_NAME}"
echo "Install command after opening package:"
echo "  /usr/local/lib/tmexclude/install.sh"
