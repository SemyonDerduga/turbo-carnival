Class Educational.Student Extends (%Library.Persistent, %Populate, Educational.Person)
{

Relationship meetings As Educational.Meeting [ Cardinality = many, Inverse = student ];

Property age As %Integer;

Index emailKey On email [ Unique ];

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
<Value>age</Value>
</Value>
<Value name="4">
<Value>email</Value>
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
