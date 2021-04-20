Class Educational.Meeting Extends (%Library.Persistent, %Library.Populate)
{

Relationship teacher As Educational.Teacher [ Cardinality = one, Inverse = meetings ];

Relationship student As Educational.Student [ Cardinality = one, Inverse = meetings ];

Relationship subject As Educational.Subject [ Cardinality = one, Inverse = meetings ];

Property time As %Integer;

Property title As %String;

Storage Default
{
<Data name="MeetingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>teacher</Value>
</Value>
<Value name="3">
<Value>student</Value>
</Value>
<Value name="4">
<Value>subject</Value>
</Value>
<Value name="5">
<Value>time</Value>
</Value>
<Value name="6">
<Value>title</Value>
</Value>
</Data>
<DataLocation>^Educational.MeetingD</DataLocation>
<DefaultData>MeetingDefaultData</DefaultData>
<IdLocation>^Educational.MeetingD</IdLocation>
<IndexLocation>^Educational.MeetingI</IndexLocation>
<StreamLocation>^Educational.MeetingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
