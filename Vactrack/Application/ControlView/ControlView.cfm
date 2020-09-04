
<cf_tl id="Recruitment Track Manager" var="1">

<cf_screenTop height="100%" title="#lt_text#" jQuery="Yes" html="No" banner="gray" bannerforce="Yes" scroll="no" validateSession="Yes">

<cf_layoutscript>

<cfajaximport tags="cfform,cftree">
<cf_calendarscript>

<cfset CLIENT.FileNo = round(rand()*20) >

<cf_wfPending entityCode="VacDocument"
      entityCode2="VacCandidate" 
	  mailfields="No" 
	  includeCompleted="No" 
	  table="#SESSION.acc#Doc3_#CLIENT.FileNo#">

<cfoutput>
	
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">	
	
	<cf_layoutarea 
	          position="header"
			  size="60"
	          name="controltop">	
					  
			<cf_ViewTopMenu label="#lt_text#">
					 
	</cf_layoutarea>


	<cf_layoutarea  position="left" name="tree" maxsize="300" size="290" collapsible="true" splitter="true">
		<cf_divScroll>
			<cfinclude template="ControlTree.cfm">
		</cf_divScroll>
	</cf_layoutarea>


	<cf_layoutarea  position="center" name="box">
				
		<iframe src="../../../Tools/Treeview/TreeViewInit.cfm"
		        name="right"
		        id="right"
		        width="100%"
		        height="100%"
				scrolling="no"
		        frameborder="0"></iframe>
			
	</cf_layoutarea>			
		
</cf_layout>	

</cfoutput>


