import { onDistro, onPlatform } from 'dotts';
import {
  aiToolsRole,
  alacrittyRole,
  cliToolsRole,
  desktopRole,
  dockerRole,
  dotfilesRole,
  languagesRole,
  packagesRole,
  systemRole,
  vaultRole,
  vpRole,
  zjstatusRole,
} from './roles';

export default () => {
  const hostUser = process.env.USER ?? 'brimmar';

  onPlatform('linux', () => {
    onDistro(['pop', 'ubuntu', 'debian'], () => {
      const pkgs = packagesRole();
      systemRole({ unzip: pkgs.unzip });
      dockerRole({ user: hostUser });
      const vp = vpRole({ curl: pkgs.curl });
      const languages = languagesRole({
        curl: pkgs.curl,
        buildEssential: pkgs['build-essential'],
        unzip: pkgs.unzip,
      });
      alacrittyRole({
        rustup: languages.rustup,
        buildEssential: pkgs['build-essential'],
      });
      cliToolsRole({
        rustup: languages.rustup,
        buildEssential: pkgs['build-essential'],
        libsslDev: pkgs['libssl-dev'],
      });
      zjstatusRole({
        rustup: languages.rustup,
      });
      desktopRole({ user: hostUser });
      aiToolsRole({ vp: vp.installNode, curl: pkgs.curl });
      dotfilesRole();
      vaultRole();
    });
  });
};
