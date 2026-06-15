# Portable conda/mamba init. Discovers the install location instead of
# hardcoding a path, so it works across machines. No-op if conda isn't present.

for _conda_root in "$HOME/miniconda3" "$HOME/anaconda3" "$HOME/miniforge3" "/opt/homebrew/Caskroom/miniconda/base" "/opt/conda"; do
  if [ -f "$_conda_root/etc/profile.d/conda.sh" ]; then
    . "$_conda_root/etc/profile.d/conda.sh"
    [ -f "$_conda_root/etc/profile.d/mamba.sh" ] && . "$_conda_root/etc/profile.d/mamba.sh"
    break
  fi
done
unset _conda_root
