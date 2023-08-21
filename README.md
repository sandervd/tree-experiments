# Tree serialization experiments

## Graph to Tree to Graph

In the current form of the tree specification, data is added to a tree:Node (page) as-is.
The resulting graph is thus a union of the data statements, as well as the hypermedia statements.

This design has a few drawbacks:
- Additional constraints need to be put in place to assure that the datagraph doesn't contain any hypermedia statements, which would cuase conflicts.
- The serialization/deserialization algoritm is dependant on the schema of the data, which creates a dependency from the transport protocol on the domain model.
- The 'graph to tree' serialization function is not defined, leaving it up to the developer to assure correctness of the algoritm. This introduces risk around data integrity.
- Lack of event boundary in the serialized format (tree): There is no notion of tree:member instances. 
This would be a very useful addition, as this would allow defining statements about the event, without resorting to reiffication.

## A different approach
The approach here focusus on establishing two bijective functions: one for serializing a graph to a 'tree' (conformant to the tree ontology) and its inverse function for deserialing a 'tree' into a graph.
These functions operate such that: graph = deserialize_to_graph(serialize_to_tree(graph))

The serialization function creates an envelope for the data, so that data is isolated from the hypermedia statements.
This allows for domain agnosting serialization/deserialization, without putting additional constraints on the source graph (the only constraint is the prohibition of cycles and dangling blank nodes, which are implicitly forbidden in tree). 

## Example
Input data
```
<http://example.com/movies/1>
        rdf:type              schema:Movie;
        schema:actor          [ rdf:type     schema:Person;
                                schema:name  "Leonardo DiCaprio";
                                schema:role  [ rdf:type        skos:Concept;
                                               skos:prefLabel  "Actor"
                                             ]
                              ];
        schema:actor          [ rdf:type     schema:Person;
                                schema:name  "Joseph Gordon-Levitt";
                                schema:role  [ rdf:type        skos:Concept;
                                               skos:prefLabel  "Actor"
                                             ]
                              ];
        schema:datePublished  "2010-07-16";
        schema:description    "A mind-bending sci-fi thriller about dreams and reality.";
        schema:director       [ rdf:type     schema:Person;
                                schema:name  "Christopher Nolan";
                                schema:role  [ rdf:type        skos:Concept;
                                               skos:prefLabel  "Director"
                                             ]
                              ];
        schema:duration       "PT148M";
        schema:genre          "Science Fiction" , "Action";
        schema:language       "English";
        schema:name           "Inception" .
```

Serialized as 'enveloped tree', this becomes:
```
[ rdf:type     tree:Collection;
  tree:member  [ tree:hasSubject    <http://example.com/movies/1>;
                 tree:memberObject  [ rdf:type              schema:Movie;
                                      schema:actor          [ rdf:type     schema:Person;
                                                              schema:name  "Leonardo DiCaprio";
                                                              schema:role  [ rdf:type        skos:Concept;
                                                                             skos:prefLabel  "Actor"
                                                                           ]
                                                            ];
                                      schema:actor          [ rdf:type     schema:Person;
                                                              schema:name  "Joseph Gordon-Levitt";
                                                              schema:role  [ rdf:type        skos:Concept;
                                                                             skos:prefLabel  "Actor"
                                                                           ]
                                                            ];
                                      schema:datePublished  "2010-07-16";
                                      schema:description    "A mind-bending sci-fi thriller about dreams and reality.";
                                      schema:director       [ rdf:type     schema:Person;
                                                              schema:name  "Christopher Nolan";
                                                              schema:role  [ rdf:type        skos:Concept;
                                                                             skos:prefLabel  "Director"
                                                                           ]
                                                            ];
                                      schema:duration       "PT148M";
                                      schema:genre          "Action" , "Science Fiction";
                                      schema:language       "English";
                                      schema:name           "Inception"
                                    ]
               ]
] .
```

After deserializing, the original graph is obtained.
