import { onDistro, onPlatform } from 'dotts';
import {
  aiToolsRole,
  cliToolsRole,
  desktopRole,
  dockerRole,
  dotfilesRole,
  languagesRole,
  packagesRole,
  systemRole,
  vaultRole,
  vpRole,
} from './roles';

export default () => {
  const hostUser = process.env.USER ?? 'brimmar';

  onPlatform('linux', () => {
    onDistro(['pop', 'ubuntu', 'debian'], () => {
      systemRole();
      packagesRole();
      dockerRole({ user: hostUser });
      vpRole();
      languagesRole();
      cliToolsRole();
      desktopRole({ user: hostUser });
      aiToolsRole();
      dotfilesRole();
      vaultRole();
    });
  });
};
