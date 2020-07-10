This repo demonstrates an issue that occurs when setting custom values for MSBuild's
`BaseOutputPath` and `BaseIntermediateOutputPath` properties for .NET Core solutions.
In short, under these circumstances the .deps.json file is often (but not always)
incomplete.

To reproduce the issue, run *repro.ps1*. This script simply repeats the following
steps in an infinite loop:

1. Build the solution, specifying custom output paths
2. Attempt to run *OutpathDemo.exe*

Sometimes this process is successful, but most of the time *OutpathDemo.exe* fails
to initialize and issues the following error message:

```
Unhandled exception. System.IO.FileNotFoundException: Could not load file or assembly 'TestLib, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null'. The system cannot find the file specified.
File name: 'TestLib, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null'
   at outpath_demo.Program.Main(String[] args)
```

If you pass `-Pause` to the repro script, it will pause after each iteration, allowing
you to inspect the output directory contents. By doing this, I noticed the following:

* *TestLib.dll* is present in spite of the fact that *OutpathDemo.exe* complains about
  not being able to find the assembly
* When everything goes smoothly *OutpathDemo.deps.json* contains information about
  TestLib, but those entries are **not** present during failing iterations
