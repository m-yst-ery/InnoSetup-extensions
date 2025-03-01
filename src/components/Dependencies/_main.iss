#ifdef BUILD
  
  #include "..\..\ispp\build_component.iss"

  #dim Component_Files[6]
  #define Component_Files[0] "customMessages.iss"
  #define Component_Files[1] "types.iss"
  #define Component_Files[2] "globals.iss"
  #define Component_Files[3] "registration.iss"
  #define Component_Files[4] "download.iss"
  #define Component_Files[5] "install.iss"

  #define Component_Namespace "Dependencies"

  #define Component_OutputDir AddBackslash(SourcePath) + "..\..\..\dist\"
  #define Component_OutputFileName "dependencies.iss"
  
  #expr Component_Build
  
#else

  [Setup]
  AppId={{1FCFBBF0-F538-4F82-A404-C331FB630076}
  AppName="Dependencies component"
  AppVersion="0"
  DefaultDirName="{src}"
  OutputDir=.\out

  #include "customMessages.iss"
  #include "types.iss"
  #include "globals.iss"
  #include "registration.iss"
  #include "download.iss"
  #include "install.iss"

#endif
