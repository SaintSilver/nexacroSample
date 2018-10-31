<%@ page import = "org.apache.commons.logging.*" %>
<%@ page import = "com.nexacro17.xapi.data.*" %>
<%@ page import = "com.nexacro17.xapi.tx.*" %>

<%!
// ResultSet ==> Dataset
public DataSet RsToDs(ResultSet rs, String dsID) throws Exception
{
	int i;
	int iColCnt;
	String sColName;
	String sColType;;
	int ColType = 0; 
	int ColSize = 255; 
	
	DataSet ds = new DataSet(dsID);
	ResultSetMetaData rsmd = rs.getMetaData();

	iColCnt = rsmd.getColumnCount();
	for( i = 1 ; i <= iColCnt ; i++ )
	{
		sColName = rsmd.getColumnName(i).toUpperCase();		
		sColType = rsmd.getColumnTypeName(i);

		ColType = DataTypes.STRING;
		if(sColType.equals("INTEGER"))	ColType = DataTypes.INT;
		if(sColType.equals("DECIMAL"))	ColType = DataTypes.DECIMAL;
		
		ds.addColumn(sColName, ColType, ColSize);
		//ds.addColumn(sColName, ColType, rsmd.getColumnDisplaySize(i));
		
/*
		switch (rsmd.getColumnType(i)) 
		{ 
			case Types.VARCHAR: 
			case Types.CHAR: 
			case Types.LONGVARCHAR: 
			case Types.CLOB: 
				ColType = DataTypes.STRING; 
				break; 
			case Types.INTEGER: 
			case Types.BIGINT: 
			case Types.SMALLINT: 
			case Types.TINYINT: 
			case Types.NUMERIC: 
				ColType = DataTypes.INT; 
				break; 
			case Types.FLOAT: 
				ColType = DataTypes.FLOAT; 
				break; 
			case Types.DOUBLE: 
			case Types.REAL: 
			case Types.DECIMAL: 
				ColType = DataTypes.DECIMAL; 
				break; 
			case Types.BINARY: 
			case Types.BLOB: 
			case Types.LONGVARBINARY: 
				ColType = DataTypes.BLOB; 
				break; 
			case Types.DATE: 
				ColType = DataTypes.DATE; 
				break; 
			case Types.TIME: 
			case Types.TIMESTAMP: 
				ColType = DataTypes.DATE_TIME; 
				break; 
			default: 
				ColType = DataTypes.STRING; 
				break; 
		} 
*/		
		
	}
	while(rs.next())
	{
		int row = ds.newRow();
		for( i = 1 ; i <= iColCnt ; i++ )
		{
			sColName = rsmd.getColumnName(i).toUpperCase();
			ds.set(row, sColName, rsGet(rs, sColName));
		}
	}

  return ds;
}

public String rsGet(ResultSet rs, String id) throws Exception
{
	if( rs.getString(id) == null ){
		return "";
	} 
	else {
		return rs.getString(id);
	}
}
%>