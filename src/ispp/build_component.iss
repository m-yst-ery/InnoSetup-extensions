// Pre-processor script for building isolated InnoSetup modules
// 
// Merges multiple files into single output file and assigns namespace to avoid name conflicts
//
// ---- Usage
// Include via
//   #include "[..]build_component.iss"
// 
// Define to-be included files in "Component_Files"
//   #dim Component_Files[{number of files}]
//   #define Component_Files[0] = {path to first file}
//   #define Component_Files[1] = {path to second file}
//                   ......
//
// Define namespace in "Component_Name" (cannot contain spaces, start with a number or any special characters other than '_')
//   #define Component_Name = "MyCoolNamespace"
//
// Execute the build with "Component_Build"
//   #expr Component_Build
//
// ---- Additional Options
// Component_OutputDir                   : Output directory. Defaults to "{location of root script}/dist/"
// Component_OutputFileName              : Name of the output file. Defaults to "_index.iss"
//
// ---- Remarks
// Running "Component_Build" aborts the compilation after pre-processor. This results in a "2" exit code.
// 
// If a [Setup] section is defined in any file (also the root script) it *will* be included in the output. This can have weird consequences for the consumer and is not recommended.

#define BuildComponent_Internals = GetSHA1OfString("internal")

#define BuildComponent_FileHandle
#define BuildComponent_FileLine

#sub BuildComponent_EmitLine
  #emit BuildComponent_FileLine
#endsub

#sub BuildComponent_ProcessFile
  #for {""; BuildComponent_FileHandle && !FileEof(BuildComponent_FileHandle); ""} \
    BuildComponent_FileLine = FileRead(BuildComponent_FileHandle), \
    BuildComponent_FileLine = StringChange(BuildComponent_FileLine, " public_", " " + Component_Namespace + "_"), \
    BuildComponent_FileLine = StringChange(BuildComponent_FileLine, " internal_", " " + Component_Namespace + "_" + BuildComponent_Internals + "_"), \
    BuildComponent_EmitLine
    
  #if BuildComponent_FileHandle
    #expr FileClose(BuildComponent_FileHandle)
  #endif
#endsub

#sub Component_Build
  // disable empty lines
  #pragma option - e -

  // disable compilation
  // only run pre-processor
  #pragma option - c -

  #ifndef Component_Files
    #error "Cannot build component: 'Component_Files' not defined"
  #endif
  
  #ifndef Component_Namespace
    #error "Cannot build component: 'Component_Namespace' not defined"
  #endif
  
  // merge all files (defined in Component_Files) and set namespace
  #define BuildComponent_Iter
  
  #for {BuildComponent_Iter = 0; BuildComponent_Iter < DimOf(Component_Files); BuildComponent_Iter++ } \
    BuildComponent_FileHandle = FileOpen(Component_Files[BuildComponent_Iter]), \
    BuildComponent_ProcessFile
    
  #undef BuildComponent_Iter
    
  
  // create and safe output file
  #ifndef Component_OutputDir
    #define Component_OutputDir = AddBackslash(SourcePath) + "dist"
  #endif
  
  #ifndef Component_OutputFileName
    #define Component_OutputFileName = "_index.iss"
  #endif
  
  #expr ForceDirectories(Component_OutputDir)
    
  #define BuildComponent_OutputFile = AddBackslash(Component_OutputDir) + Component_OutputFileName
  #expr SaveToFile(BuildComponent_OutputFile)

  #pragma message "Built component '" + Component_Namespace + "'. "
  #pragma message "Output produced in '" + BuildComponent_OutputFile + "'. "
  #pragma message "Compilation will now abort." 
#endsub
