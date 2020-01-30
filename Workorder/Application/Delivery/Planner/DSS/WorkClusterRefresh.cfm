<cfset VARIABLES.Instance.date    = DTS/>
<cfset VARIABLES.Instance.dateSQL = DateFormat(dts,"DDMMYYY")/>
<cfset VARIABLES.Instance.Mission = URL.Mission/>
<cfset SESSION.WorkPlanMission  = URL.Mission/>



<cftry>
	<!---- we create table if it is not in place--->
	<cfquery name="qCreateWP" datasource="AppsTransaction">
		CREATE TABLE stWorkPlan_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(
			Date date NOT NULL,
			Region varchar(100) NULL,
			Step int NULL,
			PositionNo int NULL,
			PersonNo varchar(20) NULL,
			ActionStatus varchar(2) NOT NULL)
	</cfquery>		
<cfcatch>	
</cfcatch>
</cftry>


<cftry>
	<!---- we create table if it is not in place--->
	<cfquery name="qCreateNodes"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		CREATE TABLE stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(
			Date date NOT NULL,
			Node varchar(40) NOT NULL,
			ZipCode varchar(10) NULL,
			OrgUnitOwner int NULL,
			WorkOrderLineId uniqueidentifier NULL,
			CustomerName varchar(50) NULL,
			Branch varchar(50) NULL,
			Latitude float NULL,
			Longitude float NULL,
			Region varchar(10) NULL,
			Distance_from_SP float NULL,
			Duration_from_SP float NULL,
			MasterRoute bit NULL,
			ActionStatus varchar(2) NULL
		 CONSTRAINT PK_stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# PRIMARY KEY CLUSTERED 
		(
			Date ASC,
			Node ASC
		)) 			
	</cfquery>
<cfcatch>	
</cfcatch>
</cftry>	

<cftry>
	<cfquery name="qCreateWPD" datasource="AppsTransaction">
		CREATE TABLE stWorkPlanDetails_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(
			Date date NOT NULL,
			Node varchar(40) NOT NULL,
			Distance float NULL,
			Duration float NULL,
			ActionStatus varchar(2) NOT NULL,
			ListingOrder int NULL,
			PlanOrder varchar(10) NULL 
			PRIMARY KEY CLUSTERED (Date ASC,Node ASC))
	</cfquery>			  		
<cfcatch>
</cfcatch>		  		
</cftry>