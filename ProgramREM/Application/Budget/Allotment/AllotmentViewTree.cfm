
<cfoutput>
	
	<script language="JavaScript">
			
		function editionselect(val) {
		
		    count = 1		
			while (count != 10) {		
		      try {	
			  se = document.getElementById('viewmode'+count)	
			  se.style.fontWeight='normal' 
			  } catch(e) {}
			  count++		  
			}		
			document.getElementById('viewmode'+val).style.fontWeight='bold'
		}
			
		function loadform() {
		    right.location = 'Allotment.cfm?mode=embed&Mission=#url.mission#&Program=#URL.Program#&editionid='+document.getElementById('edition').value+'&Period='+document.getElementById('period').value
		}	
		
		function resetform() {
	        right.location = '../../../../Tools/Treeview/TreeViewInit.cfm'
		}	
	
	</script>

</cfoutput>

<cfset Criteria = ''>
  
    <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		  
		 <cfquery name="Period" 
	       datasource="AppsProgram" 
	       username="#SESSION.login#" 
	       password="#SESSION.dbpw#">
		       SELECT   R.*, M.MandateNo, M.DefaultPeriod
			   FROM     Ref_Period R, Organization.dbo.Ref_MissionPeriod M
			   WHERE    IncludeListing = 1
			   AND      M.Mission = '#URL.Mission#' 
			   AND      R.Period  = M.Period
			   AND      R.isPlanningperiod = 1
			   AND      R.Period IN (SELECT Period 
		                    FROM   ProgramPeriod 
							WHERE  ProgramCode = '#URL.Program#'
							AND    RecordStatus = '1')		
			   ORDER BY   DateEffective
	     </cfquery>
		 
		 <cfquery name="Def" 
	       datasource="AppsProgram" 
	       username="#SESSION.login#" 
	       password="#SESSION.dbpw#">
		       SELECT   TOP 1 *
			   FROM     Ref_Period R, Organization.dbo.Ref_MissionPeriod M
			   WHERE    IncludeListing = 1
			   AND      M.Mission = '#URL.Mission#' 
			   AND      R.Period  = M.Period
			   AND      R.isPlanningperiod = 1
			   AND      R.Period IN (SELECT Period 
		                    FROM   ProgramPeriod 
							WHERE  ProgramCode = '#URL.Program#'
							AND    RecordStatus = '1')		
			   ORDER BY M.DefaultPeriod DESC
	     </cfquery>
		 	 
		 	 
		 <cfset man = "#Def.MandateNo#">
		 <cfset per = "#Def.Period#">
		 
		 <cfif url.period eq "">
	 	 	  <cfset URL.Period = "#per#">
		 </cfif>	  
	  	 		 	 	  
      <TR>
      
      <TD width="100" style="padding-left:5px;height:25">
	    <cfoutput>
		<select name="period" id="period" class="regularxl"
		    onchange="ColdFusion.navigate('AllotmentViewTreeEdition.cfm?mission=#url.mission#&programcode=#url.program#&period='+this.value,'editionsel');resetform()">
     	   <cfloop query="Period">
        	   <option value="#Period#" <cfif URL.Period eq "#Period#">selected</cfif>>#Description#</option>
           </cfloop>
	    </select>
		</cfoutput>
      </TD>
	  
	  <td class="labelit" style="padding-left:10px"></td>
	   
      <td style="width:95%;padding-left:5px" id="editionsel">
	  
	    <cfset url.programcode = url.program>
	    <cfinclude template="AllotmentViewTreeEdition.cfm">
				  		
		</td>
      </tr>
	    
    </table>
