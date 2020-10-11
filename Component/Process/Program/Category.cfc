
<!---  Name: /Component/Process/Program/Category.cfc
       Description: Program procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "ProgramRoutine">
	
	<cffunction name="CategoryControl"
             access="public"
             returntype="any"
             displayname="Determine if category item has to be shown for data entry">
		
		<cfargument name="Mission"            type="string" required="true"  default="">	
		<cfargument name="AreaCode"           type="string" required="true"  default=""> 
		<cfargument name="ProgramCode"        type="string" required="true"  default="">
		<cfargument name="Period"             type="string" required="true">
		
		<!--- it is defined if a category has to be shown within a mission through ref_ParameterMissionCategory which is the top level 


			Then we define for each item which is passedin the cluster in hierarchy, if the hierarchy item passes the control table, 

			obtain for the project top mission, program, period, parent unit -> to cfc

			check if category + pass = go

			if no, then all elements under it will not go either, next

			what is a -go-

			check category + mission + period 


			= if no records for cat, mis, -period- found = pass
	
			= records for period found and match = pass

			otherwise = hide
			
			we return a list of categorycodes that are relevant for the program / period selected --->

		--->		
		
		   
	   <cfreturn access>		
		 
   </cffunction>
   
  		
</cfcomponent>	 