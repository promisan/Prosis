<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML><HEAD><TITLE>Indicator</TITLE></HEAD>

<body leftmargin="0" topmargin="0" rightmargin="0">

<cfajaximport tags="cfform">

<!---
<cfwindow 
          name="dialog"
          title="Indicator"
          height="700"
          width="740"
          minheight="700"
          minwidth="740"
          bodystyle="overflow: hidden;"
          center="True"
          draggable="True"
          modal="True"></cfwindow>		
		  ---> 

<cfquery name="Check"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_MeasureSource
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO Ref_MeasureSource
		(Code, Description)
		VALUES ('Manual','Manual entries')
	</cfquery>

</cfif>

<cfquery name="Mis"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * FROM Ref_ParameterMission
	WHERE EnableIndicator = '1'   
</cfquery>

<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cf_divscroll>
<table width="93%" align="center" cellspacing="0" cellpadding="0">

<cfoutput>

<script>

function init(mis) {
	if (confirm("Do you want to create records ?")) 
		{
		window.location = "MeasurementInit.cfm?idmenu=#url.idmenu#&mission="+mis;
		}
	}		

function recordadd(mis) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#&mission="+mis, "Add", "left=100, top=30, width=900, height=900, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}

function recordedit(mis,id1) {
        window.open("RecordEdit.cfm?idmenu=#url.idmenu#&mission="+mis+"&ID1="+ id1, "Edit", "left=100, top=30, width=920, height=900, toolbar=no, status=yes, scrollbars=no, resizable=yes");				
	}	
		
function show(mis) {
    
	se = document.getElementById("i"+mis)
	if (se.className == "hide") {
	   se.className = "regular"	   
	   ColdFusion.navigate('RecordListingDetail.cfm?mission=' + mis,'i'+mis) 	
	   document.getElementById("i"+mis+"_col").className = "regular"
	   document.getElementById("i"+mis+"_exp").className = "hide"
	 
	} else {
	   
	   se.className = "hide"
	   document.getElementById("i"+mis+"_col").className = "hide"
	   document.getElementById("i"+mis+"_exp").className = "regular"
	 
	}
	
	}		

</script>
	
</cfoutput>
	
<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfset Ord = 0>

<cfparam name="url.mis" default="">

<cfloop query="Mis">

	<cfset tree = currentrow>

    <tr>
       
	   
	<cfoutput>
	
		<cfset show = "0">
	
	    <cfloop index="itm" list="#URL.mis#">
		  <cfif itm eq mission>
		    <cfset show = 1>
		  <cfelse>
		    <cfset show = 0>	
		  </cfif>		
		</cfloop>
	
		<cfif show eq "1">
		   <cfset cl = "hide">
			<cfset cli = "regular">			
		<cfelse>	
			<cfset cl = "regular">
			<cfset cli = "hide">
		</cfif>
		
		<td colspan="1" width="30">  
		 
		 <img src="#Client.VirtualDir#/Images/arrowdown.gif"
		     alt="Expand"
		     id="i#mission#_col"
		     width="14"
		     height="14"
		     border="0"
			 align="absmiddle"
		     class="#cli#"
		     style="cursor: pointer;"
		     onClick="javascript:show('#mission#')">
		 
		<img src="#Client.VirtualDir#/Images/arrowright.gif"
		     alt="Collapse"
		     id="i#mission#_exp"
		     width="14"
		     height="14"
		     border="0"
			 align="absmiddle"
		     class="#cl#"
		     style="cursor: pointer;"
		     onClick="javascript:show('#mission#')">
		 
		</td>
		 
		<td colspan="1" width="60" class="labellarge" style="padding-left:10px"> 
		   <a href="javascript:show('#mission#')"><font color="0080C0">#Mission#</font></a>
		</td>  
	   	  	   
		<cfquery name="Program"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT Pe.* 
			FROM  Program P, ProgramPeriod Pe
			WHERE P.ProgramCode = Pe.ProgramCode 
			AND   OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission = '#Mission#')
			AND   RecordStatus != '9'
			AND   ProgramClass = 'Component' 
		</cfquery>
		
		<cfquery name="Unit"
         dbtype="query">
			SELECT distinct OrgUnit
			FROM   Program
		</cfquery>
		<td width="90%" class="labelit">
		: <b>#Program.recordcount#</b> programs defined for <b>#Unit.recordcount#</b> units</a>
		</td>	
		
		</cfoutput>
				   
    </tr>	
	<tr>
		<cfoutput>
		<!---
		<td id="#mission#" class="#cli#">
		--->
		<cfdiv id="i#mission#" colspan="3" tagname="td" class="#cli#">
		</cfoutput>
	
	</td></tr>
		
</CFloop>

</TABLE>
</td>
</tr>
</TABLE>
</cf_divscroll>

</BODY></HTML>