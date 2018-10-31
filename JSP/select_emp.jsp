<%@ page import = "org.apache.commons.logging.*" %>
<%@ page import = "com.nexacro17.xapi.data.*" %>
<%@ page import = "com.nexacro17.xapi.tx.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page contentType = "text/xml; charset=UTF-8" %>

<%
// PlatformData
PlatformData out_pData = new PlatformData();
String sDept = (request.getParameter("sDept") == null) ? "" : request.getParameter("sDept");
	
int    nErrorCode  = 0;
String strErrorMsg = "START";

try {    
	/******* JDBC Connection *******/
	Connection conn = null;
	Statement  stmt = null;
	ResultSet  rs   = null;
	
	try { 
		Class.forName("org.sqlite.JDBC");
		conn = DriverManager.getConnection("jdbc:sqlite:C:\\Tomcat 8.0\\webapps\\EduProject\\File\\nexacro_edu_db.sqlite");

		stmt = conn.createStatement();
	  
		/******* SQL ************/
		String SQL;
		SQL  = "SELECT EMPL_ID    \n" +
			   "     , FULL_NAME  \n" +
			   "     , DEPT_CD    \n" +
			   "     , POS_CD     \n" +
			   "     , GENDER     \n" +
			   "     , HIRE_DATE  \n" +
			   "     , MARRIED    \n" +
			   "     , SALARY     \n" +
			   "     , MEMO       \n" +
			   "  FROM TB_EMP     \n" +
			   " WHERE 1=1        \n" ;
		
		if(sDept != null && sDept.length() != 0 && !sDept.equals("undefined"))
		{
			SQL += "AND DEPT_CD = '" + sDept + "'";
		}
		SQL += " ORDER BY DEPT_CD, FULL_NAME";
		
		System.out.println(SQL);        

		rs = stmt.executeQuery(SQL);
	  
		DataSet ds = new DataSet("out_emp");
		ds.addColumn("EMPL_ID" 	  ,DataTypes.STRING  ,(short)10 );
		ds.addColumn("FULL_NAME"  ,DataTypes.STRING  ,(short)50 );
		ds.addColumn("DEPT_CD"    ,DataTypes.STRING  ,(short)10 );
		ds.addColumn("POS_CD"     ,DataTypes.STRING  ,(short)10 );
		ds.addColumn("GENDER"     ,DataTypes.STRING  ,(short)10 );
		ds.addColumn("HIRE_DATE"  ,DataTypes.DATE    ,(short)10 );
		ds.addColumn("MARRIED"    ,DataTypes.STRING  ,(short)10 );
		ds.addColumn("SALARY"     ,DataTypes.INT     ,(short)10 );
		ds.addColumn("MEMO"       ,DataTypes.STRING  ,(short)10 );
			
		while(rs.next())
		{
			int row = ds.newRow();
			ds.set(row ,"EMPL_ID"       ,rs.getString("EMPL_ID")  );
			ds.set(row ,"FULL_NAME"     ,rs.getString("FULL_NAME"));
			ds.set(row ,"DEPT_CD"       ,rs.getString("DEPT_CD")  );
			ds.set(row ,"POS_CD"        ,rs.getString("POS_CD")   );
			ds.set(row ,"GENDER"        ,rs.getString("GENDER")   );
			ds.set(row ,"HIRE_DATE"     ,rs.getString("HIRE_DATE"));
			ds.set(row ,"MARRIED"       ,rs.getString("MARRIED")  );
			ds.set(row ,"SALARY"        ,rs.getString("SALARY")   );
			ds.set(row ,"MEMO"          ,rs.getString("MEMO")     );
		}
		  
		// #1 dataset -> PlatformData
		out_pData.addDataSet(ds);

		// #2 dataset -> PlatformData
		//DataSetList dsList = out_pData.getDataSetList();
		//dsList.add(ds);

		nErrorCode  = 0;
		strErrorMsg = "SUCC";
		
	} catch (SQLException e) {
		nErrorCode = -1;
		strErrorMsg = e.getMessage();
	}    
	
	/******** JDBC Close ********/
	if ( stmt != null ) try { stmt.close(); } catch (Exception e) {nErrorCode = -1; strErrorMsg = e.getMessage();}
	if ( conn != null ) try { conn.close(); } catch (Exception e) {nErrorCode = -1; strErrorMsg = e.getMessage();}
			
	} catch (Throwable th) {
		nErrorCode = -1;
		strErrorMsg = th.getMessage();
}

VariableList varList = out_pData.getVariableList();
varList.add("ErrorCode", nErrorCode);
varList.add("ErrorMsg" , strErrorMsg);


/*
Variable varErrCD = new Variable("ErrorCode");
varErrCD.set(nErrorCode);

Variable varErrMSG = new Variable("ErrorMsg");
varErrMSG.set(strErrorMsg);

out_pData.addVariable(varErrCD);
out_pData.addVariable(varErrMSG);
*/

HttpPlatformResponse pRes = new HttpPlatformResponse(response, PlatformType.CONTENT_TYPE_XML, "utf-8");
pRes.setData(out_pData);

// Send data
pRes.sendData();
%>
