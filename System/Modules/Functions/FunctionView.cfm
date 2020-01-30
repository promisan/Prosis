<cf_tl id="Module manager" var="1">


<cf_screenTop height="100%" html="No" label="#lt_text#" jQuery="yes" layout="webapps" banner="gray" bannerforce="Yes" menuAccess="Yes" border="0" scroll="no" validateSession="Yes">

<cfajaximport tags="cfdiv,cfform">
<cf_layoutscript>

<cfinclude template="FunctionViewScript.cfm">

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
          position="header"	name="controltop" maxsize="30" size="30">		      					  
			 <cfinclude template="FunctionMenu.cfm">		 			 
	</cf_layoutarea>		 
			  
	<cf_layoutarea position="left" name="tree" maxsize="400" size="290" collapsible="true" splitter="true">
	     <cf_divscroll> 
			<cfinclude template="FunctionTree.cfm">
		 </cf_divscroll>	
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="right">
			<cfinclude template="FunctionInit.cfm">
	</cf_layoutarea>			
		
</cf_layout>
