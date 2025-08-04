<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<!--- this is a custom java component to convert to PDF --->

<cfparam name="attributes.filein"    default="H:\Prosis\Apps\CFRStage\User\Administrator\Indefinido.htm">
<cfparam name="attributes.fileout"   default="#attributes.filein#">

<!--- // FileInputStream = createobject("java", "java.io.FileInputStream"); --->

<cfscript>
    Renderer        = createobject("java", "org.zefer.pd4ml.PD4ML").init();    
    fInput          = createObject("java", "java.io.File").init("#attributes.filein#.htm").toURI().toURL();
    fOut            = createobject("java", "java.io.FileOutputStream").init("#attributes.fileout#.pdf");
	Renderer.render(fInput, fOut); 

    fOut.close();   
</cfscript>