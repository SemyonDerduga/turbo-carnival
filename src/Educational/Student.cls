Class Educational.Student Extends (%Library.Persistent, %Populate, Educational.Person)
{

Relationship meetings As Educational.Meeting [ Cardinality = many, Inverse = student ];

Property info As %Library.String;

Storage Default
{
<Data name="StudentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>email</Value>
</Value>
<Value name="4">
<Value>phone</Value>
</Value>
<Value name="5">
<Value>info</Value>
</Value>
</Data>
<DataLocation>^Educational.StudentD</DataLocation>
<DefaultData>StudentDefaultData</DefaultData>
<IdLocation>^Educational.StudentD</IdLocation>
<IndexLocation>^Educational.StudentI</IndexLocation>
<StreamLocation>^Educational.StudentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
