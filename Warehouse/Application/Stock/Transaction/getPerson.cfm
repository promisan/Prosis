<!--- retrieve the item --->

<cfparam name="url.personno" default="">
<cfparam name="url.search" default="">
<cfparam name="url.mission" default="">

<script>
 try {
 document.getElementById('personselectbox').className = "hide" 
 } catch(e) {}

</script>

<cfif url.search neq "">

	<cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     Person
			WHERE    PersonNo = '#url.search#'			
	</cfquery>
	
	<cfif Person.recordcount eq "0">
		    
	    <cfoutput>
		
			<script language="JavaScript">
			
			 se = document.getElementById('personidselect').value
			 
			 if (se == '') {
			
				 if (confirm("Person not found #url.search#. Do you want to record this person ?")) {
					 try { ColdFusion.Window.destroy('dialogperson',true)} catch(e){};
					 ColdFusion.Window.create('dialogperson', 'Record person', '',{x:100,y:100,height:332,width:450,resizable:false,modal:true,center:true});
					 ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Transaction/setPerson.cfm?mission=#url.mission#','dialogperson')			
				  }
			  
			  }
			
			</script>
			
		</cfoutput>
		
		<cfabort>
	
	<cfelse>
	
		<cfset url.personNo = Person.PersonNo>
	
	</cfif>

<cfelse>	
	
	<cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Person
			WHERE    PersonNo = '#url.personno#'				
	</cfquery>

</cfif>

<cfparam name="url.mission" default="">

<cfquery name="Assignment" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     PersonAssignment A
		WHERE    PersonNo = '#url.personno#'	
		AND      AssignmentStatus IN ('0','1')			
		AND      DateExpiration >= getDate()
		<cfif url.mission neq "">
		AND      PositionNo IN (SELECT PositionNo 
		                        FROM   Position 
								WHERE  PositionNo = A.PositionNo 
								AND    Mission = '#url.mission#')
		</cfif>						
</cfquery>
	
<cfoutput>
			
	<script language="JavaScript">			
		document.getElementById('personno').value = "#url.personno#"										
	</script>		
		
	<table width="100%" cellspacing="0" style="background-color:f1f1f1">
	
		<tr class="fixlengthlist labelmedium2"><!--- <td class="labelmedium" style="padding-left:3px;width:150"><cf_space spaces="20"><cf_tl id="Name">:</td> --->
		    <td style="border:0px solid silver;padding-left:4px">#Person.FirstName# #Person.LastName#</td>
			<!---  <td class="labelmedium" style="padding-left:8px;padding-right:5px;" width="10%"><cf_space spaces="20"><cf_tl id="Nationality">:</td> --->
		    <td style="border:0px solid silver;padding-left:4px">#Person.Nationality#</td>		
		</tr>		
		
		<tr class="fixlengthlist labelmedium2"><!--- <td class="labelmedium" style="padding-left:3px"><cf_tl id="ExternalReference">:</td> --->
		    <td style="border:0px solid silver;padding-left:4px">#Person.Reference# <cfif Person.ReferenceDate neq ""><font size="1">[#dateformat(Person.ReferenceDate,CLIENT.DateFormatShow)#]</font></cfif></td>
			<!--- <td class="labelmedium" style="padding-left:8px;padding-right:5px;"><cf_tl id="Gender">:</td> --->
		    <td style="border:0px solid silver;padding-left:4px">#Person.Gender#</td>		
		</tr>	
		
		<cfif Assignment.recordcount eq "0" and Person.recordcount gte "1">
			<!----
			<tr><td style="padding-left:4px"><cf_tl id="Status">:</td>
			    <td colspan="3"><cf_tl id="No current assignment recorded"></td>			
			</tr>
			--->
		</cfif>		
		
	</table>	
	

</cfoutput>

