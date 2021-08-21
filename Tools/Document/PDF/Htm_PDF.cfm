
<!--- this is a custom java component to convert to PDF --->

<cfparam name="attributes.filein"    default="H:\Prosis\Apps\CFRStage\User\Administrator\Indefinido.htm">
<cfparam name="attributes.fileout"   default="#attributes.filein#">

<cfscript>
    Renderer        = createobject("java", "org.zefer.pd4ml.PD4ML").init();
    FileInputStream = createobject("java", "java.io.FileInputStream");
    fInput          = createObject("java", "java.io.File").init("#attributes.filein#.htm").toURI().toURL();
    fOut            = createobject("java", "java.io.FileOutputStream").init("#attributes.fileout#.pdf");
    Renderer.render(fInput, fOut);
    fOut.close();   
</cfscript>