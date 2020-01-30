
<cfparam name="URL.ProgramCode" default="">	
<cfparam name="URL.ProgramName" default="">
<cfparam name="URL.Period" default="">	
<cfset CLIENT.Sort = "OrgUnit">

<cfoutput>
<cf_screenTop height="100%" title="Progress reporting" bannerheight="4" band="No" html="No" scroll="yes" flush="Yes">

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cflayout attributeCollection="#attrib#">		


<cflayoutarea 
          position="top"
          name="controltop"
          minsize="26"
          maxsize="26"  
		  size="26"        
          splitter="true">	
				
	<cfoutput>
		  <table width="100%" bgcolor="d4d4d4" height="100%"  cellspacing="0" cellpadding="0" border="0">
		    <tr>
			  <td class="top4n">&nbsp;&nbsp;#lt_text# #URL.Mission#</td>
		  </tr>
		  </table>
	</cfoutput>	  
		 
</cflayoutarea>		 
	
<cflayoutarea  position="left" name="tree" title="Folders" maxsize="400" size="280" collapsible="true" splitter="true">

  <iframe name="left" id="left" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>	
					
		   <cf_loadpanel 
			   id="left"
			   template="ProgressViewTree.cfm?ProgramCode=#URL.ProgramCode#&ProgramName=#URL.ProgramName#&Mission=#URL.Mission#&Period=#URL.Period#">	

</cflayoutarea>

<cflayoutarea  position="center" name="box">
		
			<iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
	        name="right" id="right" width="100%" height="100%" scrolling="no"
	        frameborder="0"></iframe>
			
</cflayoutarea>			
		
</cflayout>

</cfoutput>

<cf_screenbottom html="No">
