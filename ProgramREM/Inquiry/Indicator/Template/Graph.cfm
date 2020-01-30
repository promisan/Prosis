
<!--- A. do not change --->

<cf_dialogPosition>

<cfoutput>

<script>
	
	function showdocument(vacno) {
		    window.open("#SESSION.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}

</script>

</cfoutput>

<body leftmargin="2" topmargin="2" rightmargin="0" bottommargin="0">
<!--- B. customise below --->
<table width="100%" cellspacing="0" cellpadding="0" align="center">
<tr><td align="left" height="23" bgcolor="ffffff">

<cfmenu 
    name="notemenu"
    font="verdana"
    fontsize="14"
    bgcolor="transparent"
    selecteditemcolor="C0C0C0"
    selectedfontcolor="FFFFFF">
	
<cfmenuitem 
   display="Grade"
   name="grd"
   href="javascript:reload('PostGradeBudget','yes')"
   image="#SESSION.root#/Images/bullet.png"/>
   
<cfmenuitem 
   display="Organization"
   name="org"
   href="javascript:reload('ParentNameShort','yes')"
   image="#SESSION.root#/Images/Tree.gif"/>   
   
<cfmenuitem 
   display="Post Class"
   name="cls"
   href="javascript:reload('PostClass','yes')"
   image="#SESSION.root#/Images/bullet.png"/>
   
<cfmenuitem 
   display="Occ. Group"
   name="occ"
   href="javascript:reload('OccGroupAcronym','yes')"
   image="#SESSION.root#/Images/bullet.png"/>     
   
<cfmenuitem 
   display="Summary"
   name="sum"
   href="javascript:inspect('all')"
   image="#SESSION.root#/Images/overview1.gif"/>    
			  				  	    
</cfmenu>	

</td></tr>
<tr><td class="line"></td></tr>	

<tr><td align="center">

<cfset url.indicator=Indicator.IndicatorCode>

	<cfoutput>
		<iframe 
		 name="graphdata" 
		 src="#SESSION.root#/#path#/GraphData.cfm?fileno=#fileno#&indicator=#Indicator.IndicatorCode#&auditid=#url.auditid#&targetid=#url.targetid#" 
		 width="100%" 
		 height="310" 
		 scrolling="no" 
		 frameborder="0">	
		 
		</iframe>
		
		
	</cfoutput>

</td></tr>

</table>
