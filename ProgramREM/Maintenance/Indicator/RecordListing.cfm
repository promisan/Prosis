<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<cfajaximport tags="cfform">

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

<cfset Header = "Indicator">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>
	
	function init(mis) {
		if (confirm("Do you want to create records ?")) {
			ptoken.location('MeasurementInit.cfm?idmenu=#url.idmenu#&mission='+mis);
			}
		}		
	
	function recordadd(mis) {
	    ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#&mission="+mis, "IndicatorAdd");
		}
	
	function recordedit(mis,id1) {
	    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&mission="+mis+"&ID1="+ id1, "IndicatorEdit");				
		}	
			
	function show(mis) {
	    
		se = document.getElementById("i"+mis)
		if (se.className == "hide") {
		   se.className = "regular"	   
		   ptoken.navigate('RecordListingDetail.cfm?mission=' + mis,'i'+mis) 	
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


<tr><td>

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">
		
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
			     width="12"
			     height="12"			     
			     class="#cli#"
			     style="cursor: pointer;"
			     onClick="javascript:show('#mission#')">
			 
			<img src="#Client.VirtualDir#/Images/arrowright.gif"
			     alt="Collapse"
			     id="i#mission#_exp"
			     width="12"
			     height="12"			    				
			     class="#cl#"
			     style="cursor: pointer;"
			     onClick="javascript:show('#mission#')">
			 
			</td>
			 
			<td width="60" class="labellarge" style="padding-left:10px"> 
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
				<cfdiv id="i#mission#" colspan="3" tagname="td" class="#cli#">
			</cfoutput>		
		</td>
		</tr>
		
		</CFloop>

		</TABLE>
		
		</cf_divscroll>
</td>
</tr>
</TABLE>
