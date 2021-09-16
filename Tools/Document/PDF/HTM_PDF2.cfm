
<!--- this is a custom java component to convert to PDF --->

<cfparam name="attributes.filein"    default="">
<cfparam name="attributes.fileout"   default="">

<!--- // FileInputStream = createobject("java", "java.io.FileInputStream"); --->

<cfscript>
    Renderer        = createobject("java", "org.zefer.pd4ml.PD4ML").init();    
    fInput          = createObject("java", "java.io.File").init("#attributes.filein#").toURI().toURL();
    fOut            = createobject("java", "java.io.FileOutputStream").init("#attributes.fileout#");
    Renderer.render(fInput, fOut);
    fOut.close();   
</cfscript>