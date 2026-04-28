# Dataiku Docs — dev-api-reference

## [api-reference/index]

# API Reference

Dataiku’s public API allows extensive programmatic usage, which can be leveraged using client libraries or a [REST interface](<https://doc.dataiku.com/dss/latest/publicapi/rest.html> "\(in Dataiku DSS v14\)").

Python client

Send commands to the public API from a Python program. **This is the recommended way to programmatically interact with Dataiku.**

[](<python/index.html#python-index>)

---

## [api-reference/python/agent-review]

# Agents Review

_class _dataikuapi.dss.agent_review.DSSAgentReviewTrait(_data =None_, _** kwargs_)
    

Represents the configuration of a trait for an agent review.

_property _id
    

The unique identifier of the trait. :rtype: str

_property _name
    

The name of the trait. :rtype: str

_property _description
    

The description of the trait. :rtype: str

_property _llm_id
    

The ID of the LLM used to compute this trait. :rtype: str

_property _criteria
    

The criteria or prompt used by the LLM to evaluate this trait. :rtype: str

_property _enabled
    

Whether this trait is enabled for the agent review. :rtype: bool

_property _needs_reference
    

Whether this trait requires a reference answer to be computed. :rtype: bool

_property _needs_expectations
    

Whether this trait requires expectations to be computed. :rtype: bool

_class _dataikuapi.dss.agent_review.DSSAgentReview(_dss_client_ , _project_key_ , _data_)
    

A handle to interact with an agent review on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.get_agent_review()`](<projects.html#dataikuapi.dss.project.DSSProject.get_agent_review> "dataikuapi.dss.project.DSSProject.get_agent_review") instead

_property _id
    

Unique ID of the agent review. :rtype: str

_property _name
    

Name of the agent review. :rtype: str

_property _owner
    

The owner of the agent review. :return:

_property _creation_timestamp
    

Timestamp of creation (epoch millis). :rtype: int

_property _agent_id
    

ID of the associated agent (Saved Model smart ID). :rtype: str

_property _traits
    

Traits of the agent review. :rtype: list of `DSSAgentReviewTrait`

_property _helper_llm_id
    

Id of the “helper” LLM, used to compute expectations :rtype: str

_property _nb_executions
    

Number of times a test is executed in a run :rtype: int

get_trait(_trait_id_)
    

Get a specific trait by its ID. :param str trait_id: ID of the trait to retrieve. :returns: The requested trait, or None if not found. :rtype: `DSSAgentReviewTrait`

add_trait(_trait_)
    

Add a trait to this agent review configuration. :param trait: The trait to add. :type trait: `DSSAgentReviewTrait` or dict

get_raw()
    

Get the raw agent review data. :rtype: dict

_property _agent_version
    

Version of the associated agent. :rtype: str

list_tests(_as_type ='listitems'_)
    

List all tests linked to this agent review.

Parameters:
    

**as_type** (_str_) – Type of objects to return. Can be ‘listitems’ (default) or ‘objects’.

Returns:
    

List of tests defined for this agent review.

Return type:
    

if as_type=listitems, each test as a `dataikuapi.dss.agent_review.DSSAgentReviewTestListItem`. if as_type=objects, each test is returned as a `dataikuapi.dss.agent_review.DSSAgentReviewTest`.

get_test(_test_id_)
    

Get a specific test by its ID.

Parameters:
    

**test_id** (_str_) – ID of the test to retrieve.

Returns:
    

The requested test.

Return type:
    

`DSSAgentReviewTest`

create_test(_query =None_, _reference_answer =None_, _expectations =None_)
    

Create a new test for this agent review.

Parameters:
    

  * **query** (_str_) – Query to test the agent. Optional.

  * **reference_answer** (_str_) – Reference answer. Optional.

  * **expectations** (_str_) – Expectations on the agent answer. Optional.



Returns:
    

The created test object.

Return type:
    

`DSSAgentReviewTest`

create_tests_from_dataset(_full_dataset_name_ , _query_column_ , _reference_answer_column =None_, _expectations_column =None_, _top_n =None_, _partitions =None_, _latest_partitions_n =None_)
    

Create new tests for this agent review by importing them from a dataset.

Parameters:
    

  * **full_dataset_name** (_str_) – Source dataset name.

  * **query_column** (_str_) – Name of the column containing the queries.

  * **reference_answer_column** (_str_) – Name of the column containing the reference answers. Optional.

  * **expectations_column** (_str_) – Name of the column containing the expectations. Optional.

  * **top_n** (_int_) – Only take the first n rows of the dataset. Optional.

  * **partitions** (_list_ _[__str_ _]_) – For partitioned datasets, only consider the given partitions. Optional.

  * **latest_partitions_n** (_int_) – For partitioned datasets and if partitions is not set, only consider the latest n partitions. Optional.



Returns:
    

A dictionary with keys: \- “createdTestIds”: list of ids of the created tests \- “error”: The error message if any occurred

Return type:
    

dict

export_tests_to_dataset(_full_dataset_name_ , _create_new_dataset =False_, _target_connection =None_, _test_ids =None_)
    

Export tests of this agent review to a dataset.

Parameters:
    

  * **full_dataset_name** (_str_) – Target dataset name.

  * **create_new_dataset** (_bool_) – set to True to create a new dataset.

  * **target_connection** (_str_) – If creating a new dataset, ID of the connection to use. Optional.

  * **test_ids** (_list_ _[__str_ _]_) – IDs of the tests to export. If None or empty, exports everything. Optional.



Returns:
    

A dictionary with keys: \- “exportedTestCount”: count of exported tests \- “error”: The error message if any occurred

Return type:
    

dict

perform_run(_test_ids =None_, _wait =True_, _run_name =None_)
    

Execute a run with the specified tests.

Parameters:
    

  * **test_ids** (_list_ _[__str_ _]_) – List of test IDs to run. Optional. If None or empty, all tests will be run.

  * **wait** (_bool_) – If True, the call blocks until the run is finished. If False, it returns a future history handle. Defaults to True.

  * **run_name** (_str_) – Optional name for the run.



Returns:
    

The run object if wait=True, or a future history handle if wait=False.

Return type:
    

`DSSAgentReviewRun` or [`dataikuapi.dss.future.DSSFutureWithHistory`](<other-administration.html#dataikuapi.dss.future.DSSFutureWithHistory> "dataikuapi.dss.future.DSSFutureWithHistory")

list_runs(_as_type ='listitems'_)
    

List all runs of this agent review.

Parameters:
    

**as_type** (_str_) – Type of objects to return. Can be ‘listitems’ (default) or ‘objects’.

Returns:
    

List of runs.

Return type:
    

if as_type=listitems, each run as a `DSSAgentReviewRunListItem`. if as_type=objects, each run is returned as a `DSSAgentReviewRun`.

get_run(_run_id_)
    

Get a specific run by its ID.

Parameters:
    

**run_id** (_str_) – ID of the run to retrieve.

Returns:
    

The requested run.

Return type:
    

`DSSAgentReviewRun`

save()
    

Save the agent review settings. :returns: The updated agent review. :rtype: `DSSAgentReview`

delete()
    

Delete this agent review.

_class _dataikuapi.dss.agent_review.DSSAgentReviewListItem(_dss_client_ , _project_key_ , _data_)
    

An item in a list of agent reviews.

Important

Do not instantiate this class directly. Instances are returned by [`dataikuapi.dss.project.DSSProject.list_agent_reviews()`](<projects.html#dataikuapi.dss.project.DSSProject.list_agent_reviews> "dataikuapi.dss.project.DSSProject.list_agent_reviews").

to_agent_review()
    

Get a handle to interact with this agent review.

Returns:
    

A handle on the agent review.

Return type:
    

`DSSAgentReview`

_property _id
    

Unique ID of the agent review. :rtype: str

_property _name
    

Name of the agent review. :rtype: str

_property _agent_id
    

ID of the associated agent (Saved Model smart ID). :rtype: str

_property _agent_version
    

Version of the associated agent. :rtype: str

clear() → None. Remove all items from D.
    

copy() → a shallow copy of D
    

fromkeys(_value =None_, _/_)
    

Create a new dictionary with keys from iterable and values set to value.

get(_key_ , _default =None_, _/_)
    

Return the value for key if key is in the dictionary, else default.

items() → a set-like object providing a view on D's items
    

keys() → a set-like object providing a view on D's keys
    

pop(_k_[, _d_]) → v, remove specified key and return the corresponding value.
    

If key is not found, d is returned if given, otherwise KeyError is raised

popitem()
    

Remove and return a (key, value) pair as a 2-tuple.

Pairs are returned in LIFO (last-in, first-out) order. Raises KeyError if the dict is empty.

setdefault(_key_ , _default =None_, _/_)
    

Insert key with a value of default if key is not in the dictionary.

Return the value for key if key is in the dictionary, else default.

_property _tags
    

update([_E_ , ]_**F_) → None. Update D from dict/iterable E and F.
    

If E is present and has a .keys() method, then does: for k in E: D[k] = E[k] If E is present and lacks a .keys() method, then does: for k, v in E: D[k] = v In either case, this is followed by: for k in F: D[k] = F[k]

values() → an object providing a view on D's values
    

_class _dataikuapi.dss.agent_review.DSSAgentReviewTest(_dss_client_ , _project_key_ , _data_)
    

Represents a single test in an agent review.

Important

Do not instantiate this class directly. Instances are returned by `DSSAgentReview.list_tests()` or `DSSAgentReview.create_test()`.

_property _id
    

Unique ID of the test. :rtype: str

_property _agent_review_id
    

ID of the associated agent review. :rtype: str

_property _query
    

Test query. :rtype: str

_property _reference_answer
    

Expected result of the query. :rtype: str

_property _expectations
    

Expectations on the agent answer. :rtype: str

_property _creation_timestamp
    

Timestamp of creation (epoch millis). :rtype: int

_property _created_by
    

Login of the user who created the test. :rtype: str

_property _last_modification_timestamp
    

Timestamp of last modification (epoch millis). :rtype: int

_property _last_modified_by
    

Login of the user who modified last. :rtype: str

get_raw()
    

Get the raw test data. :rtype: dict

run()
    

Execute a run with this single test.

Returns:
    

The created run object.

Return type:
    

`DSSAgentReviewRun`

save()
    

Save the test settings.

Returns:
    

The updated test.

Return type:
    

`DSSAgentReviewTest`

delete()
    

Delete this test.

_class _dataikuapi.dss.agent_review.DSSAgentReviewTestListItem(_dss_client_ , _project_key_ , _data_)
    

An item in a list of agent review tests.

Important

Do not instantiate this class directly. Instances are returned by `DSSAgentReview.list_tests()`.

to_agent_review_test()
    

Get a handle to interact with this agent review test.

Returns:
    

A handle on the agent review test.

Return type:
    

`DSSAgentReviewTest`

delete()
    

Delete this test.

_property _id
    

Unique ID of the test. :rtype: str

_property _query
    

Test query. :rtype: str

_property _reference_answer
    

Expected result of the query. :rtype: str

_property _expectations
    

Expectations on the agent answer. :rtype: str

_class _dataikuapi.dss.agent_review.DSSAgentReviewRun(_dss_client_ , _project_key_ , _data_)
    

Represents a run of an agent review (execution of tests).

Important

Do not instantiate this class directly. Instances are returned by `DSSAgentReview.get_run()`.

_property _id
    

Unique ID of the run. :rtype: str

_property _name
    

Name of the run. :rtype: str

_property _agent_review_id
    

ID of the associated agent review. :rtype: str

_property _agent_id
    

ID of the agent used in this run. :rtype: str

_property _agent_version
    

Version of the agent used in this run. :rtype: str

_property _status
    

Status of the run. :rtype: str

_property _error_message
    

Error message of the run (nullable). :rtype: str

_property _created_by
    

Login of the user who created the result. :rtype: str

get_raw()
    

Get the raw run data. :rtype: dict

list_results(_as_type ='listitems'_)
    

List all results produced by this run.

Parameters:
    

**as_type** (_str_) – Type of objects to return. Can be ‘listitems’ (default) or ‘objects’.

Returns:
    

List of results.

Return type:
    

if as_type=listitems, each run as a `DSSAgentReviewResultListItem`. if as_type=objects, each run is returned as a `DSSAgentReviewResult`.

get_result(_result_id_)
    

Get a specific result by its ID.

Parameters:
    

**result_id** (_str_) – ID of the result to retrieve.

Returns:
    

The requested result.

Return type:
    

`DSSAgentReviewResult`

abort()
    

Abort the run. :returns: The terminated run. :rtype: `DSSAgentReviewRun`

list_traits()
    

Lists traits defined for this run. :return: List of traits. :rtype: list of `DSSAgentReviewTrait`

rerun(_wait =True_, _run_name =None_)
    

Execute a new run with the same test selection.

Parameters:
    

  * **wait** (_bool_) – If True, the call blocks until the run is finished. If False, it returns a future history handle. Defaults to True.

  * **run_name** (_str_) – Optional name for the new run.



Returns:
    

The new run object if wait=True, or a future history handle if wait=False.

Return type:
    

`DSSAgentReviewRun` or [`dataikuapi.dss.future.DSSFutureWithHistory`](<other-administration.html#dataikuapi.dss.future.DSSFutureWithHistory> "dataikuapi.dss.future.DSSFutureWithHistory")

rename(_new_name_)
    

Rename the run. :param str new_name: The new name for the run. :returns: The updated run object. :rtype: `DSSAgentReviewRun`

delete()
    

Delete this run.

_class _dataikuapi.dss.agent_review.DSSAgentReviewRunListItem(_dss_client_ , _project_key_ , _data_)
    

An item in a list of agent review runs.

Important

Do not instantiate this class directly. Instances are returned by `DSSAgentReview.list_runs()`.

to_agent_review_run()
    

Get a handle to interact with this agent review run.

Returns:
    

A handle on the agent review run.

Return type:
    

`DSSAgentReviewRun`

delete()
    

Delete this run.

_property _id
    

Unique ID of the run. :rtype: str

_property _name
    

Name of the run. :rtype: str

_property _agent_review_id
    

ID of the associated agent review. :rtype: str

_property _agent_id
    

ID of the agent used in this run. :rtype: str

_property _agent_version
    

Version of the agent used in this run. :rtype: str

_class _dataikuapi.dss.agent_review.DSSAgentReviewHumanReview(_dss_client_ , _project_key_ , _data_)
    

Represents a human review (manual evaluation) of a test result.

Important

Do not instantiate this class directly. Instances are returned by `DSSAgentReviewResult.create_human_review()` or `DSSAgentReviewResult.list_human_reviews()`.

_property _id
    

Unique ID of the human review. :rtype: str

_property _result_id
    

ID of the result this human review refers to. :rtype: str

_property _comment
    

Text comment of the human review. :rtype: str

_property _like
    

Like of the human review (True for Pass, False for Fail). :rtype: bool

_property _created_by
    

Login of the user who created the review. :rtype: str

_property _last_modification_timestamp
    

Timestamp of last modification (epoch millis). :rtype: int

get_raw()
    

Get the raw human review data. :rtype: dict

save()
    

Save the human review. :returns: The updated human review. :rtype: `DSSAgentReviewHumanReview`

delete()
    

Delete this human review.

_class _dataikuapi.dss.agent_review.DSSAgentReviewHumanReviewListItem(_dss_client_ , _project_key_ , _data_)
    

An item in a list of result’s human reviews.

Important

Do not instantiate this class directly. Instances are returned by `DSSAgentReviewResult.list_human_reviews()`.

delete()
    

Delete this human review.

_property _id
    

Unique ID of the human review. :rtype: str

_property _result_id
    

ID of the result this human review refers to. :rtype: str

_property _comment
    

Text comment of the human review. :rtype: str

_property _like
    

Like of the human review (True for Pass, False for Fail). :rtype: bool

_class _dataikuapi.dss.agent_review.DSSAgentReviewTraitOverride(_dss_client_ , _project_key_ , _data_)
    

Represents an trait override (manual evaluation) of a test result.

Important

Do not instantiate this class directly. Instances are returned by `DSSAgentReviewResult.create_trait_override()` or `DSSAgentReviewResult.list_trait_overrides()`.

_property _id
    

Unique ID of the trait override. :rtype: str

_property _result_id
    

ID of the result this trait override refers to. :rtype: str

_property _like
    

Like of the trait override (True for Pass, False for Fail). :rtype: bool

_property _created_by
    

Login of the user who created the trait override. :rtype: str

_property _creation_timestamp
    

Timestamp of creation (epoch millis). :rtype: int

_property _last_modification_timestamp
    

Timestamp of last modification (epoch millis). :rtype: int

_property _last_modified_by
    

Login of the user who modified last. :rtype: str

get_raw()
    

Get the raw trait override data. :rtype: dict

save()
    

Save the trait override. :returns: The updated trait override. :rtype: `DSSAgentReviewTraitOverride`

delete()
    

Delete this trait override.

_class _dataikuapi.dss.agent_review.DSSAgentReviewTraitOverrideListItem(_dss_client_ , _project_key_ , _data_)
    

An item in a list of agent review trait overrides.

Important

Do not instantiate this class directly. Instances are returned by `DSSAgentReviewResult.list_trait_overrides()`.

delete()
    

Delete this trait override.

_property _id
    

Unique ID of the trait override. :rtype: str

_property _result_id
    

ID of the result this trait override refers to. :rtype: str

_property _like
    

Like/Dislike of the trait override (True for Pass, False for Fail). :rtype: bool

_class _dataikuapi.dss.agent_review.DSSAgentReviewTraitOutcome(_dss_client_ , _data_)
    

Represents the result of an evaluation of a trait during an agent execution.

_property _id
    

Unique ID of the trait result. :rtype: str

_property _project_key
    

Project key. :rtype: str

_property _justification
    

Justification of the trait result. :rtype: str

_property _outcome
    

Outcome of the trait result. :rtype: bool

_property _result_id
    

ID of the associated result. :rtype: str

_property _trait_id
    

ID of the trait. :rtype: str

get_raw()
    

Get the raw trait result data. :rtype: dict

_class _dataikuapi.dss.agent_review.DSSAgentReviewExecutionResult(_dss_client_ , _project_key_ , _data_)
    

Represents the execution result of an agent review test.

Important

Do not instantiate this class directly. Instances are created internally and exposed through the `DSSAgentReviewResult.execution_results` attribute.

_property _id
    

Unique ID of the execution result. :rtype: str

_property _agent_review_id
    

ID of the parent agent review. :rtype: str

_property _run_id
    

ID of the run that produced this execution. :rtype: str

_property _test_id
    

Test ID associated with this execution. :rtype: str

_property _result_id
    

Result ID linking back to the review result. :rtype: str

_property _answer
    

Answer produced during this specific execution. :rtype: str

_property _error
    

Error during this specific execution. :rtype: str

_property _creation_timestamp
    

Timestamp of creation (epoch millis). :rtype: int

_property _trait_outcomes_per_trait_id
    

Trait results for this execution, keyed by trait ID.

Return type:
    

dict[str, `DSSAgentReviewTraitOutcome`]

get_raw()
    

Get the raw data of this list object. :rtype: dict

_class _dataikuapi.dss.agent_review.DSSAgentReviewResult(_dss_client_ , _project_key_ , _data_)
    

Represents the result of an execution of tests in a run.

Important

Do not instantiate this class directly. Instances are returned by `DSSAgentReviewRun.list_results()`.

_property _id
    

Unique ID of the result. :rtype: str

_property _test_id
    

ID of the associated test. :rtype: str

_property _agent_review_id
    

ID of the associated agent review. :rtype: str

_property _run_id
    

ID of the associated run. :rtype: str

_property _query
    

Query used in the test. :rtype: str

_property _raw_query
    

Raw query (e.g. including system prompt if available). :rtype: str

_property _reference_answer
    

Expected result of the query. :rtype: str

_property _expectations
    

Expectations on the agent answer. :rtype: str

_property _tool_calls
    

Tool calls performed by the agent :rtype: str

_property _creation_timestamp
    

Timestamp of creation (epoch millis). :rtype: int

_property _agent_id
    

ID of the associated agent. :rtype: str

_property _agent_version
    

Version of the associated agent. :rtype: str

_property _created_by
    

Login of the user who created the result. :rtype: str

_property _created_by_display_name
    

Display name of the user who created the result. :rtype: str

_property _status
    

Status of the result. :rtype: str

_property _human_reviews
    

List of human reviews of this result. :rtype: list of `DSSAgentReviewHumanReview`

_property _trait_status_per_trait_id
    

Status of each trait for this result. :rtype: dict[str, str]

_property _ai_status_per_trait_id
    

AI-computed status of each trait for this result. :rtype: dict[str, str]

_property _trait_status_justification_per_trait_id
    

Justification for the status of each trait. :rtype: dict[str, str]

_property _trait_overrides
    

Trait overrides of human reviewers, grouped by trait ID. :rtype: dict[str, list of `DSSAgentReviewTraitOverride`]

_property _execution_results
    

Execution results of the agent. :rtype: list of `DSSAgentReviewExecutionResult`

get_raw()
    

Get the raw result data. :rtype: dict

get_trait_override(_trait_override_id_)
    

Get a specific trait override by its ID.

Parameters:
    

**trait_override_id** (_str_) – ID of the trait override to retrieve.

Returns:
    

The requested trait override.

Return type:
    

`DSSAgentReviewTraitOverride`

create_trait_override(_trait_id_ , _like_)
    

Create a trait override for this trait result.

Parameters:
    

  * **trait_id** (_str_) – ID of the trait to override.

  * **like** (_bool_) – True for like (Pass), False for dislike (Fail).



Returns:
    

The created trait override.

Return type:
    

`DSSAgentReviewTraitOverride`

list_trait_overrides(_as_type ='listitems'_)
    

List all trait overrides for this trait result.

Parameters:
    

**as_type** (_str_) – Type of objects to return. Can be ‘listitems’ (default) or ‘objects’.

Returns:
    

List of trait overrides.

Return type:
    

if as_type=listitems, each trait override is returned as a `DSSAgentReviewTraitOverrideListItem`. if as_type=objects, each trait override is returned as a `DSSAgentReviewTraitOverride`.

get_human_review(_human_review_id_)
    

Get a specific human review by its ID.

Parameters:
    

**human_review_id** (_str_) – ID of the human review to retrieve.

Returns:
    

The requested human review.

Return type:
    

`DSSAgentReviewHumanReview`

create_human_review(_comment =None_, _like =None_)
    

Create a human review for this trait result.

Parameters:
    

  * **comment** (_str_) – Text comment. Optional.

  * **like** (_bool_) – Like of the review (True for Pass, False for Fail). Optional.



Returns:
    

The created human review.

Return type:
    

`DSSAgentReviewHumanReview`

list_human_reviews(_as_type ='listitems'_)
    

List all human reviews for this result.

Parameters:
    

**as_type** (_str_) – Type of objects to return. Can be ‘listitems’ (default) or ‘objects’.

Returns:
    

List of human reviews.

Return type:
    

if as_type=’listitems’, each human review is returned as a `DSSAgentReviewHumanReviewListItem`. if as_type=’objects’, each human review is returned as a `DSSAgentReviewHumanReview`.

_class _dataikuapi.dss.agent_review.DSSAgentReviewResultListItem(_dss_client_ , _project_key_ , _data_)
    

An item in a list of agent review results.

Important

Do not instantiate this class directly. Instances are returned by `DSSAgentReviewRun.list_results()`.

to_agent_review_result()
    

Get a handle to interact with this agent review result.

Returns:
    

A handle on the agent review result.

Return type:
    

`DSSAgentReviewResult`

_property _id
    

Unique ID of the result. :rtype: str

_property _test_id
    

ID of the associated test. :rtype: str

_property _agent_review_id
    

ID of the associated agent review. :rtype: str

_property _run_id
    

ID of the associated run. :rtype: str

_property _query
    

Query used in the test. :rtype: str

_property _raw_query
    

Raw query (e.g. including system prompt if available). :rtype: str

_property _reference_answer
    

Expected result of the query. :rtype: str

_property _expectations
    

Expectations on the agent answer. :rtype: str

_property _creation_timestamp
    

Timestamp of creation (epoch millis). :rtype: int

_property _agent_id
    

ID of the associated agent. :rtype: str

_property _agent_version
    

Version of the associated agent. :rtype: str

_property _created_by
    

Login of the user who created the result. :rtype: str

_property _created_by_display_name
    

Display name of the user who created the result. :rtype: str

_property _status
    

Status of the result. :rtype: str

_property _trait_status_per_trait_id
    

Status of each trait for this result. :rtype: dict[str, str]

_property _ai_status_per_trait_id
    

AI-computed status of each trait for this result. :rtype: dict[str, str]

_property _trait_status_justification_per_trait_id
    

Justification for the status of each trait. :rtype: dict[str, str]

get_raw()
    

Get the raw data of this list item. :rtype: dict

---

## [api-reference/python/agents]

# Agents

For usage information and examples, please see [Agents](<../../concepts-and-examples/agents.html>)

_class _dataikuapi.dss.agent.DSSAgentListItem(_client_ , _data_)
    

An item in a list of agents

Important

Do not instantiate this class directly, instead use [`dataikuapi.dss.project.DSSProject.list_agents()`](<projects.html#dataikuapi.dss.project.DSSProject.list_agents> "dataikuapi.dss.project.DSSProject.list_agents").

_property _project_key
    

Returns:
    

The project

Return type:
    

string

_property _id
    

Returns:
    

The id of the agent.

Return type:
    

string

_property _name
    

Returns:
    

The name of the agent.

Return type:
    

string

as_llm()
    

Returns this agent as a usable [`dataikuapi.dss.llm.DSSLLM`](<llm-mesh.html#dataikuapi.dss.llm.DSSLLM> "dataikuapi.dss.llm.DSSLLM") for querying

_class _dataikuapi.dss.agent.DSSAgent(_client_ , _project_key_ , _id_)
    

A handle to interact with a DSS-managed agent.

Important

Do not create this class directly, use [`dataikuapi.dss.project.DSSProject.get_agent()`](<projects.html#dataikuapi.dss.project.DSSProject.get_agent> "dataikuapi.dss.project.DSSProject.get_agent") instead.

_property _id
    

as_llm()
    

Returns this agent as a usable [`dataikuapi.dss.llm.DSSLLM`](<llm-mesh.html#dataikuapi.dss.llm.DSSLLM> "dataikuapi.dss.llm.DSSLLM") for querying

get_settings()
    

Get the agent’s definition

Returns:
    

a handle on the agent definition

Return type:
    

`dataikuapi.dss.agent.DSSAgentSettings`

delete()
    

Delete the agent

shutdown(_version_id =None_, _force =False_)
    

Shutdown all instances of the given version of this agent

Parameters:
    

  * **version_id** (_str_ _|__None_) – If unspecified, uses the active version.

  * **force** (_bool_) – If True, cancel requests being processed and stop the instances. If False, let those active requests complete before stopping.




status(_version_id =None_)
    

Query status of instances of the given version of this agent

Parameters:
    

**version_id** (_str_ _|__None_) – If unspecified, uses the active version.

Returns:
    

A dict holding the list of the status for each instance.

wake_up(_version_id =None_)
    

Start an instance of an agent if none is started

Parameters:
    

**version_id** (_str_ _|__None_) – If unspecified, uses the active version.

_class _dataikuapi.dss.agent.DSSAgentSettings(_client_ , _settings_)
    

Settings for a agent

Important

Do not instantiate directly, use `dataikuapi.dss.agent.DSSAgent.get_settings()` instead

get_version_ids()
    

_property _active_version
    

Returns the active version of this agent. May return None if no version is declared as active

get_version_settings(_version_id_)
    

_property _type
    

get_raw()
    

Returns the raw settings of the agent :return: the raw settings of the agent :rtype: dict

save()
    

Saves the settings for this agent

_class _dataikuapi.dss.agent.DSSAgentVersionSettings(_settings_ , _version_settings_)
    

get_raw()
    

_property _llm_id
    

Only for Visual Agents :rtype: `str`

_property _tools
    

Returns the list of tools of the agent. The list can be modified.

Each tool is a dict, containing at least “toolRef”, which is the identifier of the tool. The dict may also contain “additionalDescription” which is added to the description of the tool

add_tool(_tool_)
    

Adds a tool to the agent

Parameters:
    

**tool** – a string (identifier of the tool), or a `dataikuapi.dss.agent_tool.DSSAgentTool`

_property _interaction_logging_selection
    

Get the interaction logging selection for this version.

Before configuring interaction logging on an agent version, create the target dataset on the project:
    
    
    project = client.get_project("MYPROJECT")
    project.create_agent_interaction_logging_dataset(
        "agent_logs",
        connection_id="filesystem_managed",
        time_partitioning="DAY",
    )
    

Example using inherited settings:
    
    
    agent = project.get_agent("my_agent")
    agent_settings = agent.get_settings()
    version_settings = agent_settings.get_version_settings("v1")
    
    agent_logging_selection = version_settings.interaction_logging_selection
    agent_logging_selection.inherit()
    
    agent_settings.save()
    

Example using explicit settings:
    
    
    agent = project.get_agent("my_agent")
    agent_settings = agent.get_settings()
    version_settings = agent_settings.get_version_settings("v1")
    
    agent_logging_selection = version_settings.interaction_logging_selection
    agent_logging_selection.enable(
        "agent_logs",
        settings={
            "flushEveryS": 60,
            "flushEveryBytes": 1_000_000,
            "contentMode": "FULL",
        },
    )
    
    agent_settings.save()
    

Example disabling interaction logging:
    
    
    agent = project.get_agent("my_agent")
    agent_settings = agent.get_settings()
    version_settings = agent_settings.get_version_settings("v1")
    
    agent_logging_selection = version_settings.interaction_logging_selection
    agent_logging_selection.disable()
    
    agent_settings.save()
    

Return type:
    

`dataikuapi.dss.agent.DSSAgentInteractionLoggingSelection`

_class _dataikuapi.dss.agent.DSSAgentInteractionLoggingSettings(_settings_)
    

Settings for agent interaction logging.

Important

Do not instantiate this class directly, use `dataikuapi.dss.agent.DSSAgentInteractionLoggingSelection.settings` instead.

CONTENT_MODE_FULL _ = 'FULL'_
    

CONTENT_MODE_NO_LOGS _ = 'NO_LOGS'_
    

CONTENT_MODE_NO_LOGS_NO_TRACE _ = 'NO_LOGS_NO_TRACE'_
    

get_raw()
    

Returns the raw interaction logging settings.

Return type:
    

dict

get(_key_ , _default =None_)
    

_property _dataset_name
    

The dataset name used for interaction logging.

Return type:
    

str | None

_property _write_as_user
    

The DSS user used to write logs.

This value is read-only and is set automatically to the user who saves the agent settings.

Return type:
    

str | None

_property _flush_every_s
    

The flush interval, in seconds.

Return type:
    

int | None

_property _flush_every_bytes
    

The maximum buffered payload size before a flush.

Return type:
    

int | None

_property _content_mode
    

The content logging mode.

Return type:
    

str | None

_class _dataikuapi.dss.agent.DSSAgentInteractionLoggingSelection(_selection_)
    

Selection for agent interaction logging.

Important

Do not instantiate this class directly, use `dataikuapi.dss.agent.DSSAgentVersionSettings.interaction_logging_selection` instead.

MODE_INHERIT _ = 'INHERIT'_
    

MODE_EXPLICIT _ = 'EXPLICIT'_
    

MODE_NONE _ = 'NONE'_
    

get_raw()
    

Returns the raw interaction logging selection.

Return type:
    

dict

get(_key_ , _default =None_)
    

_property _mode
    

The interaction logging mode. One of INHERIT, EXPLICIT or NONE.

In `INHERIT` mode, settings are inherited from the project-level configuration.

Return type:
    

str | None

_property _settings
    

The explicit interaction logging settings.

These settings are only used when the selection is in `EXPLICIT` mode.

Return type:
    

`dataikuapi.dss.agent.DSSAgentInteractionLoggingSettings`

enable(_dataset_name_ , _settings =None_)
    

Enable interaction logging on this agent version with explicit settings.

This only controls the agent version setting itself. Interaction logging can still be effectively unavailable if it is disabled at the instance level.

Parameters:
    

  * **dataset_name** (_str_) – Dataset name used for interaction logging.

  * **settings** (dict | `dataikuapi.dss.agent.DSSAgentInteractionLoggingSettings` | None) – Optional explicit settings payload or `dataikuapi.dss.agent.DSSAgentInteractionLoggingSettings`.




inherit()
    

Enable interaction logging on this agent version in inherited mode.

In this mode, the version inherits the project-level interaction logging settings.

disable()
    

Disable interaction logging on this agent version.

_class _dataikuapi.dss.agent_tool.DSSAgentToolListItem(_client_ , _project_key_ , _data_)
    

Important

Do not instantiate this class directly, instead use [`dataikuapi.dss.project.DSSProject.list_agent_tools()`](<projects.html#dataikuapi.dss.project.DSSProject.list_agent_tools> "dataikuapi.dss.project.DSSProject.list_agent_tools").

to_agent_tool()
    

Convert the current item.

_property _id
    

Returns:
    

The id of the tool.

Return type:
    

string

_property _type
    

Returns:
    

The type of the tool

Return type:
    

string

_property _name
    

Returns:
    

The name of the tool

Return type:
    

string

_class _dataikuapi.dss.agent_tool.DSSAgentTool(_client_ , _project_key_ , _tool_id_ , _descriptor =None_)
    

Important

Do not instantiate this class directly, instead use [`dataikuapi.dss.project.DSSProject.get_agent_tool()`](<projects.html#dataikuapi.dss.project.DSSProject.get_agent_tool> "dataikuapi.dss.project.DSSProject.get_agent_tool").

_property _id
    

Returns:
    

The id of the tool.

Return type:
    

string

get_descriptor()
    

Get the descriptor of the tool

Returns:
    

a descriptor of the tool

Return type:
    

dict

get_settings()
    

Get the agent tools’ settings

Returns:
    

a handle on the tool settings

Return type:
    

`dataikuapi.dss.agent_tool.DSSAgentToolSettings` or a subclass

delete()
    

Delete the agent tool

as_langchain_structured_tool(_context =None_)
    

run(_input_ , _context =None_, _subtool_name =None_, _memory_fragment =None_, _tool_validation_responses =None_, _tool_validation_requests =None_)
    

Execute a tool call

describe_tool_call(_input_ , _descriptor_ , _context =None_, _subtool_name =None_)
    

Get a description for a tool call before it is executed

Returns:
    

a string description of the tool call

Return type:
    

Optional[str]

_class _dataikuapi.dss.agent_tool.DSSAgentToolCreator(_project_ , _type_ , _name_ , _id_)
    

Helper to create new agent tools

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_agent_tool()`](<projects.html#dataikuapi.dss.project.DSSProject.new_agent_tool> "dataikuapi.dss.project.DSSProject.new_agent_tool") instead.

create()
    

Creates the new agent tool in the project, and return a handle to interact with it.

Return type:
    

`dataikuapi.dss.agent_tool.DSSAgentTool`

_class _dataikuapi.dss.agent_tool.DSSAgentToolSettings(_agent_tool_ , _settings_)
    

get_raw()
    

_property _params
    

The parameters of the tool, as a dict. Changes to the dict will be reflected when saving

save()
    

Saves the settings of the agent tool

_property _custom_fields
    

The custom fields of the object as a dict. Returns None if there are no custom fields

_property _description
    

The description of the object as a string

_property _short_description
    

The short description of the object as a string

_property _tags
    

The tags of the object, as a list of strings

_class _dataikuapi.dss.agent_tool.DSSVectorStoreSearchAgentToolCreator(_project_ , _type_ , _name_ , _id_)
    

with_knowledge_bank(_kb_)
    

create()
    

Creates the new agent tool in the project, and return a handle to interact with it.

Return type:
    

`dataikuapi.dss.agent_tool.DSSAgentTool`

_class _dataikuapi.dss.agent_tool.DSSVectorStoreSearchAgentToolSettings(_agent_tool_ , _settings_)
    

set_knowledge_bank(_kb_)
    

_property _custom_fields
    

The custom fields of the object as a dict. Returns None if there are no custom fields

_property _description
    

The description of the object as a string

get_raw()
    

_property _params
    

The parameters of the tool, as a dict. Changes to the dict will be reflected when saving

save()
    

Saves the settings of the agent tool

_property _short_description
    

The short description of the object as a string

_property _tags
    

The tags of the object, as a list of strings

---

## [api-reference/python/api-deployer]

# API Deployer

_class _dataikuapi.dss.apideployer.DSSAPIDeployer(_client_)
    

Handle to interact with the API Deployer.

Do not create this directly, use `dataikuapi.dss.DSSClient.get_apideployer()`

list_deployments(_as_objects =True_)
    

Lists deployments on the API Deployer

Parameters:
    

**as_objects** (_boolean_) – if True, returns a list of `DSSAPIDeployerDeployment`, else returns a list of dict. Each dict contains at least a field “id” indicating the identifier of this deployment

Returns:
    

a list - see as_objects for more information

Return type:
    

list

get_deployment(_deployment_id_)
    

Returns a handle to interact with a single deployment, as a `DSSAPIDeployerDeployment`

Parameters:
    

**deployment_id** (_str_) – Identifier of the deployment to get

Return type:
    

`DSSAPIDeployerDeployment`

create_deployment(_deployment_id_ , _service_id_ , _infra_id_ , _version_ , _endpoint_id =None_, _ignore_warnings =False_, _authorizations_to_query_through_deployer =None_)
    

Creates a deployment and returns the handle to interact with it. The returned deployment is not yet started and you need to call `start_update()`

Parameters:
    

  * **deployment_id** (_str_) – Identifier of the deployment to create

  * **service_id** (_str_) – Identifier of the API Service to target

  * **infra_id** (_str_) – Identifier of the deployment infrastructure to use

  * **version** (_str_) – Identifier of the API Service version to deploy

  * **endpoint_id** (_str_) – Identifier of the endpoint to deploy if you use a Deploy Anywhere infra. Ignored otherwise

  * **ignore_warnings** (_boolean_) – Ignore warnings concerning the governance status of the model version(s) to deploy

  * **authorizations_to_query_through_deployer** (_list_) – List of group authorizations allowing query-through-deployer.




Each item is a dict with keys:
    

  * “group”: name of the group

  * “queryThroughDeployer”: boolean indicating if the group can query through the deployer




Example:
    
    
    authorizations_to_query_through_deployer = [
        {
            "group": "administrators",
            "queryThroughDeployer": True
        }
    ]
    

Return type:
    

`DSSAPIDeployerDeployment`

list_stages()
    

Lists infrastructure stages of the API Deployer

Return type:
    

list of dict. Each dict contains a field “id” for the stage identifier and “desc” for its description.

Return type:
    

list

list_infras(_as_objects =True_)
    

Lists deployment infrastructures on the API Deployer

Parameters:
    

**as_objects** (_boolean_) – if True, returns a list of `DSSAPIDeployerInfra`, else returns a list of dict. Each dict contains at least a field “id” indicating the identifier of this infra

Returns:
    

a list - see as_objects for more information

Return type:
    

list

create_infra(_infra_id_ , _stage_ , _type_ , _govern_check_policy ='NO_CHECK'_)
    

Creates a new infrastructure on the API Deployer and returns the handle to interact with it.

Parameters:
    

  * **infra_id** (_str_) – Unique Identifier of the infra to create

  * **stage** (_str_) – Infrastructure stage. Stages are configurable on each API Deployer

  * **type** (_str_) – STATIC, K8S, AZURE_ML, SAGEMAKER, SNOWPARK or VERTEX_AI

  * **govern_check_policy** (_str_) – PREVENT, WARN, or NO_CHECK depending if the deployer will check whether the saved model versions deployed on this infrastructure has to be managed and approved in Dataiku Govern



Return type:
    

`DSSAPIDeployerInfra`

get_infra(_infra_id_)
    

Returns a handle to interact with a single deployment infra, as a `DSSAPIDeployerInfra`

Parameters:
    

**infra_id** (_str_) – Identifier of the infra to get

Return type:
    

`DSSAPIDeployerInfra`

list_services(_as_objects =True_)
    

Lists API services on the API Deployer

Parameters:
    

**as_objects** (_boolean_) – if True, returns a list of `DSSAPIDeployerService`, else returns a list of dict. Each dict contains at least a field “id” indicating the identifier of this Service

Returns:
    

a list - see as_objects for more information

Return type:
    

list

create_service(_service_id_)
    

Creates a new API Service on the API Deployer and returns the handle to interact with it.

Parameters:
    

**service_id** (_str_) – Identifier of the API Service to create

Return type:
    

`DSSAPIDeployerService`

get_service(_service_id_)
    

Returns a handle to interact with a single service, as a `DSSAPIDeployerService`

Parameters:
    

**service_id** (_str_) – Identifier of the API service to get

Return type:
    

`DSSAPIDeployerService`

## Infrastructures

_class _dataikuapi.dss.apideployer.DSSAPIDeployerInfra(_client_ , _infra_id_)
    

An API Deployer infrastructure.

Do not create this directly, use `get_infra()`

_property _id
    

get_status()
    

Returns status information about this infrastructure

Return type:
    

`dataikuapi.dss.apideployer.DSSAPIDeployerInfraStatus`

get_settings()
    

Gets the settings of this infra. If you want to modify the settings, you need to call `save()` on the returned object

Returns:
    

a `dataikuapi.dss.apideployer.DSSAPIDeployerInfraSettings`

delete()
    

Deletes this infra You may only delete an infra if it has no deployments on it anymore.

_class _dataikuapi.dss.apideployer.DSSAPIDeployerInfraSettings(_client_ , _infra_id_ , _settings_)
    

The settings of an API Deployer infrastructure

Do not create this directly, use `get_settings()`

get_type()
    

Gets the type of this infra

Returns:
    

the type of this infra

Return type:
    

string

add_apinode(_url_ , _api_key_ , _graphite_prefix =None_)
    

Adds an API node to the list of nodes of this infra.

Only applicable to STATIC infrastructures

Parameters:
    

  * **url** (_str_) – url of the API node that will be added to this infra

  * **api_key** (_str_) – api key secret to connect to the API node

  * **graphite_prefix** (_str_) – graphite prefix for metric reports if graphite is configured




remove_apinode(_node_url_)
    

Removes a node from the list of nodes of this infra. Only applicable to STATIC infrastructures

Parameters:
    

**node_url** (_str_) – URL of the node to remove

get_raw()
    

Gets the raw settings of this infra. This returns a reference to the raw settings, not a copy, so changes made to the returned object will be reflected when saving.

Return type:
    

dict

save()
    

Saves back these settings to the infra

_class _dataikuapi.dss.apideployer.DSSAPIDeployerInfraStatus(_client_ , _infra_id_ , _light_status_)
    

The status of an API Deployer infrastructure.

Do not create this directly, use `get_status()`

get_deployments()
    

Returns the deployments that are deployed on this infrastructure

Returns:
    

a list of deployments

Return type:
    

list of `dataikuapi.dss.apideployer.DSSAPIDeployerDeployment`

get_raw()
    

Gets the raw status information. This returns a dictionary with various information about the infrastructure

Return type:
    

dict

## API Services

_class _dataikuapi.dss.apideployer.DSSAPIDeployerService(_client_ , _service_id_)
    

An API service on the API Deployer

Do not create this directly, use `get_service()`

_property _id
    

get_status()
    

Returns status information about this service. This is used mostly to get information about which versions are available and which deployments are exposing this service

Return type:
    

dataikuapi.dss.apideployer.DSSAPIDeployerServiceStatus

import_version(_fp_)
    

Imports a new version for an API service from a file-like object pointing to a version package Zip file

Parameters:
    

**fp** (_string_) – A file-like object pointing to a version package Zip file

get_settings()
    

Gets the settings of this service. If you want to modify the settings, you need to call `save()` on the returned object.

The main things that can be modified in a service settings are permissions

Returns:
    

a `dataikuapi.dss.apideployer.DSSAPIDeployerServiceSettings`

delete_version(_version_)
    

Deletes a version from this service

Parameters:
    

**version** (_string_) – The version to delete

get_version_stream(_version_id_)
    

Download a version of a service as a stream.

The archive of this version can then be deployed in a DSS API Node.

Warning

This call will monopolize the DSSClient until the stream it returns is closed.
    
    
    with api_deployer_service.get_version_stream('v1') as fp:
        # use fp
    
    # or explicitly close the stream after use
    fp = api_deployer_service.get_version_stream('v1')
    # use fp, then close
    fp.close()
    

Parameters:
    

**version_id** (_string_) – version (identifier) of the package to download

Returns:
    

the package archive, as an HTTP stream

Return type:
    

file-like

download_version_to_file(_version_id_ , _path_)
    

Download an archive of a version to a local file.

The archive can then be deployed in a DSS API Node.

Parameters:
    

  * **version_id** (_string_) – version (identifier) of the package to download

  * **path** (_string_) – absolute or relative path to a file in which the package is downloaded




delete()
    

Deletes this service

You may only delete a service if it has no deployments on it anymore.

_class _dataikuapi.dss.apideployer.DSSAPIDeployerServiceSettings(_client_ , _service_id_ , _settings_)
    

The settings of an API Deployer Service.

Do not create this directly, use `get_settings()`

get_raw()
    

Gets the raw settings of this deployment. This returns a reference to the raw settings, not a copy, so changes made to the returned object will be reflected when saving.

Return type:
    

dict

save()
    

Saves back these settings to the API service

_class _dataikuapi.dss.apideployer.DSSAPIDeployerServiceStatus(_client_ , _service_id_ , _light_status_)
    

The status of an API Deployer Service.

Do not create this directly, use `get_status()`

get_deployments(_infra_id =None_)
    

Returns the deployments that have been created from this published project

Parameters:
    

**infra_id** (_str_) – Identifier of an infra, allows to only keep in the returned list the deployments on this infra. If not set, the list contains all the deployments using this published project, across every infra of the Project Deployer.

Returns:
    

a list of deployments

Return type:
    

list of `dataikuapi.dss.apideployer.DSSAPIDeployerDeployment`

get_versions()
    

Returns the versions of this service that have been published on the API Service

Each version is a dict that contains at least a “id” field, which is the version identifier

Returns:
    

a list of versions, each as a dict containing a “id” field

Return type:
    

list of dicts

get_raw()
    

Gets the raw status information. This returns a dictionary with various information about the service,

Return type:
    

dict

## Deployments

_class _dataikuapi.dss.apideployer.DSSAPIDeployerDeployment(_client_ , _deployment_id_)
    

A Deployment on the API Deployer

Do not create this directly, use `get_deployment()`

_property _id
    

get_status()
    

Returns status information about this deployment

Return type:
    

dataikuapi.dss.apideployer.DSSAPIDeployerDeploymentStatus

get_governance_status(_version =''_)
    

Returns the governance status about this deployment if applicable It covers all the embedded model versions

Parameters:
    

**version** (_str_) – (Optional) The specific package version of the published service to get status from. If empty, consider all the versions used in the deployment generation mapping.

Return type:
    

dict InforMessages containing the governance status

get_settings()
    

Gets the settings of this deployment. If you want to modify the settings, you need to call `save()` on the returned object

Returns:
    

a `dataikuapi.dss.apideployer.DSSAPIDeployerDeploymentSettings`

start_update()
    

Starts an asynchronous update of this deployment to try to match the actual state to the current settings

Returns:
    

a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") tracking the progress of the update. Call [`wait_for_result()`](<other-administration.html#dataikuapi.dss.future.DSSFuture.wait_for_result> "dataikuapi.dss.future.DSSFuture.wait_for_result") on the returned object to wait for completion (or failure)

delete(_disable_first =False_, _ignore_pre_delete_errors =False_)
    

Deletes this deployment. The disable_first flag automatically disables the deployment before its deletion.

Parameters:
    

  * **disable_first** (_boolean_) – If True, automatically disables this deployment before deleting it. If False, will raise an Exception if this deployment is enabled.

  * **ignore_pre_delete_errors** (_boolean_) – If True, any error occurred during the actions performed previously to delete the deployment will be ignored and the delete action will be performed anyway.




get_open_api()
    

Gets the OpenAPI document of this deployment if it’s available or raise a 404 error.

Returns:
    

a `dataikuapi.dss.apideployer.DSSAPIDeployerDeploymentOpenApi`

run_test_queries(_endpoint_id =None_, _test_queries =None_)
    

Runs test queries on a deployment and returns results as a dict

Parameters:
    

  * **endpoint_id** (_str_) – Mandatory if the deployment has multiple endpoints

  * **test_queries** (_list_) – Queries as str, formatted as [{“q”: {“features”: {“feat_1”: “value”, …}}, {…}, … ]. If left to None, the test queries of the current version of the service will be used.



Return type:
    

dict

Usage example
    
    
    import dataiku
    
    client = dataiku.api_client()
    deployer = client.get_apideployer()
    deployment = deployer.get_deployment('service14');
    
    test_queries = [{'q': {'features': {
        'Pclass': '200',
        'Sex': 'male',
        'Age': '22',
        'Embarked': 'S'
    }}}]
    
    # run existing test queries on deployment endpoint (if unique, else error)
    test_queries_result = deployment.run_test_queries()
    
    # run specified test queries on deployment "survived" endpoint
    test_queries_result = deployment.run_test_queries(endpoint_id="survived", test_queries=test_queries)
    
    # run existing test queries on deployment  "survived" endpoint
    test_queries_result = deployment.run_test_queries(endpoint_id="survived")
    
    # run specified test queries on deployment endpoint (if unique, else error)
    test_queries_result = deployment.run_test_queries(test_queries=test_queries)
    

list_updates()
    

Retrieves a list of available deployment updates. Each element contains start timestamp, type and status fields

Returns:
    

a list of deployment updates

Return type:
    

list of dataikuapi.dss.apideployer.DSSAPIDeployerDeploymentUpdateListItem

get_update(_timestamp =None_)
    

Retrieves a specific deployment update by timestamp, or the most recent update if no timestamp is provided

Parameters:
    

**timestamp** (_(__optional_ _)__string_) – The timestamp that uniquely identifies the update to retrieve

Return type:
    

dataikuapi.dss.apideployer.DSSAPIDeployerDeploymentUpdate

run_queries(_queries_ , _endpoint_id =None_, _adapt_query_for_infra_type =True_)
    

Runs queries on a deployment and returns results as a dict An authorization to query the deployment through the deployer is needed

Parameters:
    

  * **queries** (_list_) – Queries as str, formatted as `[{"q": {"features": {"feat_1": "value", ...}}, {...}, ... ]`.

  * **endpoint_id** (_str_) – Mandatory if the deployment has multiple endpoints

  * **adapt_query_for_infra_type** (_bool_) – If True, automatically adjusts the query format to be compatible with the target infrastructure type. This is mainly applicable to Deploy-Anywhere infrastructures. Defaults to True.



Return type:
    

dict

Usage example
    
    
    import dataiku
    
    client = dataiku.api_client()
    deployer = client.get_apideployer()
    deployment = deployer.get_deployment('service14');
    
    queries = [{'q': {'features': {
        'Pclass': '200',
        'Sex': 'male',
        'Age': '22',
        'Embarked': 'S'
    }}}]
    
    # run queries on deployment "survived" endpoint
    queries_results = deployment.run_queries(endpoint_id="survived")
    
    # run queries on deployment endpoint (if unique, else error)
    queries_results = deployment.run_queries(queries)
    

_class _dataikuapi.dss.apideployer.DSSAPIDeployerDeploymentSettings(_client_ , _deployment_id_ , _settings_)
    

The settings of an API Deployer deployment.

Do not create this directly, use `get_settings()`

get_raw()
    

Gets the raw settings of this deployment. This returns a reference to the raw settings, not a copy, so changes made to the returned object will be reflected when saving.

Return type:
    

dict

set_enabled(_enabled_)
    

Enables or disables this deployment

Parameters:
    

**enabled** (_bool_) – True/False to Enable/Disable this deployment

set_single_version(_version_)
    

Sets this deployment to target a single version of the API service

Parameters:
    

**version** (_str_) – Identifier of the version to set

save(_ignore_warnings =False_)
    

Saves back these settings to the deployment

Parameters:
    

**ignore_warnings** (_boolean_) – ignore warnings concerning the governance status of the model version(s) to deploy

_class _dataikuapi.dss.apideployer.DSSAPIDeployerDeploymentStatus(_client_ , _deployment_id_ , _light_status_ , _heavy_status_)
    

The status of an API Deployer deployment.

Do not create this directly, use `get_status()`

get_light()
    

Gets the ‘light’ (summary) status. This returns a dictionary with various information about the deployment, but not the actual health of the deployment

Return type:
    

dict

get_heavy()
    

Gets the ‘heavy’ (full) status. This returns a dictionary with various information about the deployment

Return type:
    

dict

get_service_urls()
    

Returns service-level URLs for this deployment (ie without the enpdoint-specific suffix)

Returns:
    

a list of service-level URLs for this deployment

Return type:
    

list

get_health()
    

Returns the health of this deployment as a string

Returns:
    

HEALTHY if the deployment is working properly, various other status otherwise

Return type:
    

string

get_health_messages()
    

Returns messages about the health of this deployment

_class _dataikuapi.dss.apideployer.DSSAPIDeployerDeploymentOpenApi(_open_api_doc_json_)
    

The OpenAPI document of an API Deployer deployment.

Do not create this directly, use `get_open_api()`

get()
    

Gets the OpenAPI document as dict.

Return type:
    

dict

get_raw()
    

Gets the OpenAPI document raw.

Return type:
    

string

_class _dataikuapi.dss.apideployer.DSSAPIDeployerDeploymentUpdate(_update_)
    

Represents an API Deployer’s deployment update.

This class should not be instantiated directly. Use `get_update()` to obtain instances of this class

_property _start_time
    

_property _end_time
    

_property _requester
    

_property _status
    

_property _logs
    

Returns the logs for this update as a list of lines:
    

  * Each line represents a single log entry

  * The list preserves the original order of the log output




Returns:
    

List of log lines, or None if no logs are available

Return type:
    

list[str] or None

get_raw()
    

Returns the raw data of this deployment update as a dictionary

Returns:
    

a deployment update, as a dict

Return type:
    

dict

_class _dataikuapi.dss.apideployer.DSSAPIDeployerDeploymentUpdateListItem(_client_ , _deployment_id_ , _data_)
    

Represents a single item in a list of API Deployer’s deployment updates.

This class should not be instantiated directly. Instead, use `list_updates()` to retrieve instances of this class.

_property _start_time
    

_property _type
    

_property _status
    

get_raw()
    

Returns the raw dictionary representation of this deployment update list item

Returns:
    

a deployment update list item, as a dict

Return type:
    

dict

get_full_update()
    

Returns the full deployment update corresponding to this list item, as a `DSSAPIDeployerDeploymentUpdate`

Returns:
    

a fully detailed deployment update

Return type:
    

`DSSAPIDeployerDeploymentUpdate`

---

## [api-reference/python/api-designer]

# API Designer

Please see [API Designer](<../../concepts-and-examples/api-designer/index.html>) for an introduction to interacting with datasets in Dataiku Python API

_class _dataikuapi.dss.apiservice.DSSAPIServiceListItem(_client_ , _data_)
    

An item in a list of API services.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.list_api_services()`](<projects.html#dataikuapi.dss.project.DSSProject.list_api_services> "dataikuapi.dss.project.DSSProject.list_api_services")

to_api_service()
    

Get a handle corresponding to this API service.

Return type:
    

`DSSAPIService`

_property _name
    

Get the name of the API service.

Return type:
    

string

_property _id
    

Get the identifier of the API service.

Return type:
    

string

_property _auth_method
    

Get the method used to authenticate on the API service.

Usage example:
    
    
    # list all public API services
    for service in project.list_api_services(as_type="list_item"):
        if service.auth_method == 'PUBLIC':
            print("Service {} isn't authenticating requests".format(service.id))
    

Returns:
    

an authentication method. Possible values: PUBLIC (no authentication), API_KEYS, OAUTH2

Return type:
    

string

_property _endpoints
    

Get the endpoints in this API service.

Returns:
    

a list of endpoints, each one a dict with fields:

  * **id** : identifier of the endpoint

  * **type** : type of endpoint. Possible values: STD_PREDICTION, STD_CLUSTERING, STD_FORECAST, STD_CAUSAL_PREDICTION, CUSTOM_PREDICTION, CUSTOM_R_PREDICTION, R_FUNCTION, PY_FUNCTION, DATASETS_LOOKUP, SQL_QUERY




Return type:
    

list[dict]

_class _dataikuapi.dss.apiservice.DSSAPIServiceSettings(_client_ , _project_key_ , _service_id_ , _settings_)
    

The settings of an API Service in the API Designer.

Important

Do not instantiate directly, use `DSSAPIService.get_settings()`.

get_raw()
    

Get the raw settings of this API Service.

This returns a reference to the raw settings, not a copy, so changes made to the returned object will be reflected when saving.

Returns:
    

the settings of the API service, as a dict. The definitions of the endpoints are inside the **endpoints** field, itself a list of dict.

Return type:
    

dict

_property _auth_method
    

Get the method used to authenticate on the API service

Returns:
    

an authentication method. Possible values: PUBLIC (no authentication), API_KEYS, OAUTH2

Return type:
    

string

_property _endpoints
    

Get the list of endpoints of this API service

Returns:
    

ist of endpoints, each one a dict. Endpoint have different fields depending on their type, but always have at least:

  * **id** : identifier of the endpoint

  * **type** : type of endpoint. Possible values: STD_PREDICTION, STD_CLUSTERING, STD_FORECAST, STD_CAUSAL_PREDICTION, CUSTOM_PREDICTION, CUSTOM_R_PREDICTION, R_FUNCTION, PY_FUNCTION, DATASETS_LOOKUP, SQL_QUERY




Return type:
    

list[dict]

add_prediction_endpoint(_endpoint_id_ , _saved_model_id_)
    

Add a new “visual prediction” endpoint to this API service.

Parameters:
    

  * **endpoint_id** (_string_) – identifier of the new endpoint to create

  * **saved_model_id** (_string_) – identifier of the saved model (that is currently deployed to the Flow) to use




add_clustering_endpoint(_endpoint_id_ , _saved_model_id_)
    

Add a new “visual clustering” endpoint to this API service.

Parameters:
    

  * **endpoint_id** (_string_) – identifier of the new endpoint to create

  * **saved_model_id** (_string_) – identifier of the saved model (that is currently deployed to the Flow) to use




add_forecasting_endpoint(_endpoint_id_ , _saved_model_id_)
    

Add a new “visual time series forecasting” endpoint to this API service.

Parameters:
    

  * **endpoint_id** (_string_) – identifier of the new endpoint to create

  * **saved_model_id** (_string_) – identifier of the saved model (that is currently deployed to the Flow) to use




add_causal_prediction_endpoint(_endpoint_id_ , _saved_model_id_ , _compute_propensity =False_)
    

Add a new “visual causal prediction” endpoint to this API service.

Parameters:
    

  * **endpoint_id** (_string_) – identifier of the new endpoint to create

  * **saved_model_id** (_string_) – identifier of the saved model (that is currently deployed to the Flow) to use

  * **compute_propensity** (_bool_) – whether propensity should be computed, if True, the model must have a trained propensity model




save()
    

Save back these settings to the API Service.

_class _dataikuapi.dss.apiservice.DSSAPIService(_client_ , _project_key_ , _service_id_)
    

An API Service from the API Designer on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.get_api_service()`](<projects.html#dataikuapi.dss.project.DSSProject.get_api_service> "dataikuapi.dss.project.DSSProject.get_api_service")

_property _id
    

Get the API service’s identifier

Return type:
    

string

get_settings()
    

Get the settings of this API Service.

Usage example:
    
    
    # list all API services using a given model
    model_lookup = "my_saved_model_id"
    model = project.get_saved_model(model_lookup)
    model_name = model.get_settings().get_raw()["name"]
    for service in project.list_api_services(as_type='object'):
        settings = service.get_settings()
        endpoints_on_model = [e for e in settings.endpoints if e.get("modelRef", '') == model_lookup]
        if len(endpoints_on_model) > 0:
            print("Service {} uses model {}".format(service.id, model_name))
    

Returns:
    

a handle on the settings

Return type:
    

`DSSAPIServiceSettings`

get_package_summary(_package_id_)
    

Get summary of a package

Parameters:
    

**package_id** (_str_) – version (identifier) of the package to get the summary for

Return type:
    

dict

list_packages()
    

List the versions of this API service.

Returns:
    

a list of packages, each one as a dict. Each dict has fields:

  * **id** : version (identifier) of the package

  * **createdOn** : timestamp in milliseconds of when the package was created




Return type:
    

list[dict]

create_package(_package_id_ , _release_notes =None_)
    

Create a new version of this API service.

Parameters:
    

  * **package_id** (_string_) – version (identifier) of the package to create

  * **release_notes** (_str_) – important changes introduced in the package




delete_package(_package_id_)
    

Delete a version of this API service.

Parameters:
    

**package_id** (_string_) – version (identifier) of the package to delete

download_package_stream(_package_id_)
    

Download an archive of a package as a stream.

The archive can then be deployed in a DSS API Node.

Warning

This call will monopolize the DSSClient until the stream it returns is closed.

Parameters:
    

**package_id** (_string_) – version (identifier) of the package to download

Returns:
    

the package archive, as a HTTP stream

Return type:
    

file-like

download_package_to_file(_package_id_ , _path_)
    

Download an archive of a package to a local file.

The archive can then be deployed in a DSS API Node.

Parameters:
    

  * **package_id** (_string_) – version (identifier) of the package to download

  * **path** (_string_) – absolute or relative path to a file in which the package is downloaded




publish_package(_package_id_ , _published_service_id =None_)
    

Publish a package on the API Deployer.

Parameters:
    

  * **package_id** (_string_) – version (identifier) of the package to publish

  * **published_service_id** (_string_) – identifier of the API service on the API Deployer in which the package will be published. A new published API service will be created if none matches the identifier. If the parameter is not set, the identifier from the current `DSSAPIService` is used.

---

## [api-reference/python/authinfo]

# Authentication information and impersonation

For usage information and examples, see [Authentication information and impersonation](<../../concepts-and-examples/authinfo.html>)

DSSClient.get_auth_info(_with_secrets =False_)
    

Returns various information about the user currently authenticated using this instance of the API client.

This method returns a dict that may contain the following keys (may also contain others):

  * authIdentifier: login for a user, id for an API key

  * groups: list of group names (if context is an user)

  * secrets: list of dicts containing user secrets (if context is an user)




Param:
    

with_secrets boolean: Return user secrets

Returns:
    

a dict

Return type:
    

dict

DSSClient.get_auth_info_from_browser_headers(_headers_dict_ , _with_secrets =False_)
    

Returns various information about the DSS user authenticated by the dictionary of HTTP headers provided in headers_dict.

This is generally only used in webapp backends

This method returns a dict that may contain the following keys (may also contain others):

  * authIdentifier: login for a user, id for an API key

  * groups: list of group names (if context is an user)

  * secrets: list of dicts containing user secrets (if context is an user)




Param:
    

headers_dict dict: Dictionary of HTTP headers

Param:
    

with_secrets boolean: Return user secrets

Returns:
    

a dict

Return type:
    

dict

---

## [api-reference/python/bigframes]

# Bigframes

For usage information and examples, see [Bigframes](<../../concepts-and-examples/bigframes.html>)

_class _dataiku.bigframes.DkuBigframes(_session_ordering_mode ='partial'_)
    

Handle to create Bigframes sessions from DSS datasets or connections

create_session(_connection_name_ , _project_key =None_)
    

Creates a new session configured to read on the supplied DSS connection.

get_dataframe(_dataset_ , _session =None_)
    

Return a DataFrame configured to read the table that is underlying the specified dataset.

get_session(_connection_name_ , _project_key =None_)
    

Return session configured to read on the supplied DSS connection.

write_dataframe(_dataset_ , _df_ , _infer_schema =False_, _force_direct_write =False_, _dropAndCreate =False_)
    

Writes this dataset (or its target partition, if applicable) from a single dataframe.

This variant only edit the schema if infer_schema is True, otherwise you must take care to only write dataframes that have a compatible schema. Also see “write_with_schema”.

Parameters:
    

  * **df** – input dataframe.

  * **dataset** – Output dataset to write.

  * **infer_schema** – infer the schema from the dataframe.

  * **force_direct_write** – Force writing the dataframe using the direct API into the dataset even if they don’t come from the same DSS connection.

  * **dropAndCreate** – if infer_schema and this parameter are both set to True, clear and recreate the dataset structure.




write_with_schema(_dataset_ , _df_ , _force_direct_write =False_, _dropAndCreate =False_)
    

Writes this dataset (or its target partition, if applicable) from a single dataframe.

This variant replaces the schema of the output dataset with the schema of the dataframe.

Parameters:
    

  * **df** – input dataframe.

  * **dataset** – Output dataset to write.

  * **force_direct_write** – Force writing the dataframe using the direct API into the dataset even if they don’t come from the same DSS connection.

  * **dropAndCreate** – drop and recreate the dataset.

---

## [api-reference/python/client]

# The main API client

The dataikuapi.DSSClient class is the entry point for many of the capabilities of the Dataiku API.

_class _dataikuapi.DSSClient(_host_ , _api_key =None_, _internal_ticket =None_, _extra_headers =None_, _no_check_certificate =False_, _client_certificate =None_, _** kwargs_)
    

Entry point for the DSS API client

list_futures(_as_objects =False_, _all_users =False_)
    

List the currently-running long tasks (a.k.a futures)

Parameters:
    

  * **as_objects** (_boolean_) – if True, each returned item will be a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

  * **all_users** (_boolean_) – if True, returns futures for all users (requires admin privileges). Else, only returns futures for the user associated with the current authentication context (if any)



Returns:
    

list of futures. if as_objects is True, each future in the list is a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture"). Else, each future in the list is a dict. Each dict contains at least a ‘jobId’ field

Return type:
    

list of [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") or list of dict

list_running_scenarios(_all_users =False_)
    

List the running scenarios

Parameters:
    

**all_users** (_boolean_) – if True, returns scenarios for all users (requires admin privileges). Else, only returns scenarios for the user associated with the current authentication context (if any)

Returns:
    

list of running scenarios, each one as a dict containing at least a “jobId” field for the future hosting the scenario run, and a “payload” field with scenario identifiers

Return type:
    

list of dicts

get_future(_job_id_)
    

Get a handle to interact with a specific long task (a.k.a future). This notably allows aborting this future.

Parameters:
    

**job_id** (_str_) – the identifier of the desired future (which can be returned by `list_futures()` or `list_running_scenarios()`)

Returns:
    

A handle to interact the future

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

list_running_notebooks(_as_objects =True_)
    

List the currently-running Jupyter notebooks

Parameters:
    

**as_objects** (_boolean_) – if True, each returned item will be a [`dataikuapi.dss.notebook.DSSNotebook`](<other-administration.html#dataikuapi.dss.notebook.DSSNotebook> "dataikuapi.dss.notebook.DSSNotebook")

Returns:
    

list of notebooks. if as_objects is True, each entry in the list is a [`dataikuapi.dss.notebook.DSSNotebook`](<other-administration.html#dataikuapi.dss.notebook.DSSNotebook> "dataikuapi.dss.notebook.DSSNotebook"). Else, each item in the list is a dict which contains at least a “name” field.

Return type:
    

list of [`dataikuapi.dss.notebook.DSSNotebook`](<other-administration.html#dataikuapi.dss.notebook.DSSNotebook> "dataikuapi.dss.notebook.DSSNotebook") or list of dict

get_root_project_folder()
    

Get a handle to interact with the root project folder.

Returns:
    

A [`dataikuapi.dss.projectfolder.DSSProjectFolder`](<project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder> "dataikuapi.dss.projectfolder.DSSProjectFolder") to interact with this project folder

get_project_folder(_project_folder_id_)
    

Get a handle to interact with a project folder.

Parameters:
    

**project_folder_id** (_str_) – the project folder ID of the desired project folder

Returns:
    

A [`dataikuapi.dss.projectfolder.DSSProjectFolder`](<project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder> "dataikuapi.dss.projectfolder.DSSProjectFolder") to interact with this project folder

list_project_keys()
    

List the project keys (=project identifiers).

Returns:
    

list of project keys identifiers, as strings

Return type:
    

list of strings

list_projects(_include_location =False_)
    

List the projects

Parameters:
    

**include_location** (_bool_) – whether to include project locations (slower)

Returns:
    

a list of projects, each as a dict. Each dict contains at least a ‘projectKey’ field

Return type:
    

list of dicts

get_project(_project_key_)
    

Get a handle to interact with a specific project.

Parameters:
    

**project_key** (_str_) – the project key of the desired project

Returns:
    

A [`dataikuapi.dss.project.DSSProject`](<projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject") to interact with this project

get_default_project()
    

Get a handle to the current default project, if available (i.e. if dataiku.default_project_key() is valid)

create_project(_project_key_ , _name_ , _owner_ , _description =None_, _settings =None_, _project_folder_id =None_, _permissions =None_, _tags =[]_)
    

Creates a new project, and return a project handle to interact with it.

Note: this call requires an API key with admin rights or the rights to create a project

Parameters:
    

  * **project_key** (_str_) – the identifier to use for the project. Must be globally unique

  * **name** (_str_) – the display name for the project.

  * **owner** (_str_) – the login of the owner of the project.

  * **description** (_str_) – a description for the project.

  * **settings** (_dict_) – Initial settings for the project (can be modified later). The exact possible settings are not documented.

  * **project_folder_id** (_str_) – the project folder ID in which the project will be created (root project folder if not specified)

  * **permissions** (_list_ _[__dict_ _]_) – Initial permissions for the project (can be modified later). Each dict contains a ‘group’ and permissions given to that group.

  * **tags** (_list_ _[__str_ _]_) – a list of tags for the project



Returns:
    

A [`dataikuapi.dss.project.DSSProject`](<projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject") project handle to interact with this project

list_apps(_as_type ='listitems'_)
    

List the apps.

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects” (defaults to **listitems**).

Returns:
    

The list of the apps. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.app.DSSAppListItem`](<dataiku-applications.html#dataikuapi.dss.app.DSSAppListItem> "dataikuapi.dss.app.DSSAppListItem"). If “as_type” is “objects”, each one as a [`dataikuapi.dss.app.DSSApp`](<dataiku-applications.html#dataikuapi.dss.app.DSSApp> "dataikuapi.dss.app.DSSApp")

Return type:
    

list

get_app(_app_id_)
    

Get a handle to interact with a specific app.

Note

If a project XXXX is an app template, the identifier of the associated app is PROJECT_XXXX

Parameters:
    

**app_id** (_str_) – the id of the desired app

Returns:
    

A [`dataikuapi.dss.app.DSSApp`](<dataiku-applications.html#dataikuapi.dss.app.DSSApp> "dataikuapi.dss.app.DSSApp") to interact with this project

list_business_apps(_as_type ='listitems'_)
    

List the installed Business Applications.

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects” (defaults to **listitems**).

Returns:
    

The list of the Business Applications. If “as_type” is “listitems”, each one as a `dataikuapi.dss.businessapp.DSSBusinessAppListItem`. If “as_type” is “objects”, each one as a `dataikuapi.dss.businessapp.DSSBusinessApp`

Return type:
    

list

get_business_app(_business_app_id_)
    

Get a handle to interact with a specific Business Application.

Parameters:
    

**business_app_id** (_str_) – the id of the desired Business Application

Returns:
    

A `dataikuapi.dss.businessapp.DSSBusinessApp` to interact with this Business Application

Return type:
    

`dataikuapi.dss.businessapp.DSSBusinessApp`

install_business_app_from_archive(_fp_)
    

Install or upgrade a Business Application from a zip archive. Code-env creation must be done separately by calling DSSClient.create_code_env.

Note

This call requires an API key with admin rights

Parameters:
    

**fp** (_object_) – A file-like object pointing to a Business Application zip

Returns:
    

a future representing the installation/upgrade process

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

list_plugins()
    

List the installed plugins

Returns:
    

list of dict. Each dict contains at least a ‘id’ field

download_plugin_stream(_plugin_id_)
    

Download a development plugin, as a binary stream :param str plugin_id: identifier of the plugin to download

Parameters:
    

**plugin_id** – 

Returns:
    

the binary stream

download_plugin_to_file(_plugin_id_ , _path_)
    

Download a development plugin to a file

Parameters:
    

  * **plugin_id** (_str_) – identifier of the plugin to download

  * **path** (_str_) – the path where to download the plugin



Returns:
    

None

install_plugin_from_archive(_fp_)
    

Install a plugin from a plugin archive (as a file object)

Parameters:
    

**fp** (_object_) – A file-like object pointing to a plugin archive zip

start_install_plugin_from_archive(_fp_)
    

Install a plugin from a plugin archive (as a file object) Returns immediately with a future representing the process done asynchronously

Parameters:
    

**fp** (_object_) – A file-like object pointing to a plugin archive zip

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the install process

Return type:
    

[`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

install_plugin_from_store(_plugin_id_)
    

Install a plugin from the Dataiku plugin store

Parameters:
    

**plugin_id** (_str_) – identifier of the plugin to install

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the install process

install_plugin_from_git(_repository_url_ , _checkout ='master'_, _subpath =None_)
    

Install a plugin from a Git repository. DSS must be setup to allow access to the repository.

Parameters:
    

  * **repository_url** (_str_) – URL of a Git remote

  * **checkout** (_str_) – branch/tag/SHA1 to commit. For example “master”

  * **subpath** (_str_) – Optional, path within the repository to use as plugin. Should contain a ‘plugin.json’ file



Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the install process

get_plugin(_plugin_id_)
    

Get a handle to interact with a specific plugin

Parameters:
    

**plugin_id** (_str_) – the identifier of the desired plugin

Returns:
    

A `dataikuapi.dss.project.DSSPlugin`

sql_query(_query_ , _connection =None_, _database =None_, _dataset_full_name =None_, _pre_queries =None_, _post_queries =None_, _type ='sql'_, _extra_conf =None_, _script_steps =None_, _script_input_schema =None_, _script_output_schema =None_, _script_report_location =None_, _read_timestamp_without_timezone_as_string =True_, _read_date_as_string =False_, _project_key =None_, _datetimenotz_read_mode ='AS_IS'_, _dateonly_read_mode ='AS_IS'_)
    

Initiate a SQL, Hive or Impala query and get a handle to retrieve the results of the query.

Internally, the query is run by DSS. The database to run the query on is specified either by passing a connection name, or by passing a database name, or by passing a dataset full name (whose connection is then used to retrieve the database)

Parameters:
    

  * **query** (_str_) – the query to run

  * **connection** (_str_) – the connection on which the query should be run (exclusive of database and dataset_full_name)

  * **database** (_str_) – the database on which the query should be run (exclusive of connection and dataset_full_name)

  * **dataset_full_name** (_str_) – the dataset on the connection of which the query should be run (exclusive of connection and database)

  * **pre_queries** (_list_) – (optional) array of queries to run before the query

  * **post_queries** (_list_) – (optional) array of queries to run after the query

  * **type** (_str_) – the type of query : either ‘sql’, ‘hive’ or ‘impala’ (default: sql)

  * **project_key** (_str_) – The project_key on which the query should be run (especially useful for user isolation/impersonation scenario)

  * **datetimenotz_read_mode** (_str_) – if set to ‘AS_IS’, read SQL data types that map to the ‘datetime no tz’ DSS type as such. If set to ‘AS_STRING’, read them as strings, straight from the database (ie: conversion to string is done by the database, according to its own settings). If set to ‘AS_DATE’, read them as the DSS ‘datetime with tz’ type, in the UTC timezone. Default ‘AS_IS’

  * **dateonly_read_mode** (_str_) – if set to ‘AS_IS’, read SQL data types that map to the ‘date only’ DSS type as such. If set to ‘AS_STRING’, read them as strings, straight from the database. If set to ‘AS_DATE’, read them as the DSS ‘datetime with tz’ type, in the UTC timezone. Default ‘AS_IS’



Returns:
    

a handle on the SQL query

Return type:
    

[`dataikuapi.dss.sqlquery.DSSSQLQuery`](<sqlquery.html#dataikuapi.dss.sqlquery.DSSSQLQuery> "dataikuapi.dss.sqlquery.DSSSQLQuery")

list_users_info()
    

Gets basic information about users on the DSS instance.

You do not need to be admin to call this

Returns:
    

A list of users, as a list of `dataikuapi.dss.admin.DSSUserInfo`

list_groups_info()
    

Gets basic information about groups on the DSS instance.

You do not need to be admin to call this

Returns:
    

A list of groups, as a list of `dataikuapi.dss.admin.DSSGroupInfo`

list_users(_as_objects =False_, _include_settings =False_)
    

List all users setup on the DSS instance

Note: this call requires an API key with admin rights

Parameters:
    

  * **as_objects** (_bool_) – Return a list of [`dataikuapi.dss.admin.DSSUser`](<users-groups.html#dataikuapi.dss.admin.DSSUser> "dataikuapi.dss.admin.DSSUser") instead of dictionaries. Defaults to False.

  * **include_settings** (_bool_) – Include detailed user settings in the response. Only useful if as_objects is False, as [`dataikuapi.dss.admin.DSSUser`](<users-groups.html#dataikuapi.dss.admin.DSSUser> "dataikuapi.dss.admin.DSSUser") already includes settings by default. Defaults to False.



Returns:
    

A list of users, as a list of [`dataikuapi.dss.admin.DSSUser`](<users-groups.html#dataikuapi.dss.admin.DSSUser> "dataikuapi.dss.admin.DSSUser") if as_objects is True, else as a list of dicts

Return type:
    

list of [`dataikuapi.dss.admin.DSSUser`](<users-groups.html#dataikuapi.dss.admin.DSSUser> "dataikuapi.dss.admin.DSSUser") or list of dicts

get_user(_login_)
    

Get a handle to interact with a specific user

Parameters:
    

**login** (_str_) – the login of the desired user

Returns:
    

A [`dataikuapi.dss.admin.DSSUser`](<users-groups.html#dataikuapi.dss.admin.DSSUser> "dataikuapi.dss.admin.DSSUser") user handle

create_user(_login_ , _password_ , _display_name =''_, _source_type ='LOCAL'_, _groups =None_, _profile ='DATA_SCIENTIST'_, _email =None_)
    

Create a user, and return a handle to interact with it

Note: this call requires an API key with admin rights

Note: this call is not available to Dataiku Cloud users

Parameters:
    

  * **login** (_str_) – the login of the new user

  * **password** (_str_) – the password of the new user

  * **display_name** (_str_) – the displayed name for the new user

  * **source_type** (_str_) – the type of new user. Admissible values are ‘LOCAL’ or ‘LDAP’

  * **groups** (_list_) – the names of the groups the new user belongs to (defaults to [])

  * **profile** (_str_) – The profile for the new user. Typical values (depend on your license): FULL_DESIGNER, DATA_DESIGNER, AI_CONSUMER, …

  * **email** (_str_) – The email for the new user.



Returns:
    

A [`dataikuapi.dss.admin.DSSUser`](<users-groups.html#dataikuapi.dss.admin.DSSUser> "dataikuapi.dss.admin.DSSUser") user handle

create_users(_users_)
    

Create multiple users, and return a list of creation status

Note: this call requires an API key with admin rights

Note: this call is not available to Dataiku Cloud users

Parameters:
    

**users** (_list_) – 

a list of dictionaries where each dictionary contains the parameters for user creation. It should contain the following keys:

  * ’login’ (str): the login of the new user

  * ’password’ (str): the password of the new user

  * ’displayName’ (str): the displayed name for the new user

  * ’sourceType’ (str): the type of new user. Admissible values are ‘LOCAL’ or ‘LDAP’. Defaults to ‘LOCAL’

  * ’groups’ (list): the names of the groups the new user belongs to

  * ’userProfile’ (str): The profile for the new user. Typical values (depend on your license): FULL_DESIGNER, DATA_DESIGNER, AI_CONSUMER, … Defaults to ‘DATA_SCIENTIST’

  * ’email’ (str): The email for the new user. Defaults to None




Return type:
    

list[dict]

Returns:
    

A list of dictionaries, where each dictionary represents the creation status of a user. It should contain the following keys:

  * ’login’ (str): the login of the created user

  * ’status’ (str): the creation status of the user. Can be ‘SUCCESS’ or ‘FAILURE’

  * ’error’ (str): the error that occurred during that user’s creation. Empty if status is not ‘FAILURE’.




edit_users(_user_changes_)
    

Edits multiple users in a single bulk operation. This method is very permissive and is intended for mass operations. If you are modifying a small number of users, it is advised to get a handle from the get_user method and interact directly with a DSSUser object.

A valid workflow is to get the full users dictionaries from list_users(include_settings=True), modify them and use this method to apply the modifications.

Note: This call requires an API key with admin rights.

Note: this call is not available to Dataiku Cloud users

Parameters:
    

**user_changes** (_list_ _[__dict_ _]_) – 

A list of dictionaries, where each dictionary defines the changes for a single user. Each dictionary **must** contain the ‘login’ key to identify the user. Other keys can be included to modify the user’s properties, matching the structure of a user settings object (see the output of list_users(include_settings=True)). Available keys include:

  * ’login’ (str): The login of the user to modify (mandatory). Cannot be modified.

  * ’displayName’ (str): The user’s display name.

  * ’email’ (str): The user’s email address.

  * ’groups’ (list[str]): The list of groups for the user.

  * ’userProfile’ (str): The user’s profile (e.g., ‘FULL_DESIGNER’).

  * ’enabled’ (bool): Whether the user is enabled.

  * ’sourceType’: User provisioning source type. Admissible values are ‘LOCAL’ or ‘LDAP’.

  * ’adminProperties’ (dict): Custom admin properties for the user.

  * ’userProperties’ (dict): Custom user properties for the user.

  * ’secrets’ (list): A list of user-specific secrets.

  * ’preferences’ (dict): A dictionary of user preferences:

>     * ’uiLanguage’ (str): UI language code (e.g., ‘en’, ‘ja’, ‘fr’).
> 
>     * ’mentionEmails’ (bool): Email notifications for mentions.
> 
>     * ’discussionEmails’ (bool): Email notifications for discussions.
> 
>     * ’accessRequestEmails’ (bool): Email notifications for access requests.
> 
>     * ’grantedAccessEmails’ (bool): Email notifications when access is granted.
> 
>     * ’grantedPluginRequestEmails’ (bool): Email notifications when a plugin request is granted.
> 
>     * ’pluginRequestEmails’ (bool): Email notifications for plugin requests.
> 
>     * ’instanceAccessRequestsEmails’ (bool): Email notifications for instance access requests.
> 
>     * ’profileUpgradeRequestsEmails’ (bool): Email notifications for profile upgrade requests.
> 
>     * ’codeEnvCreationRequestEmails’ (bool): Email notifications for code env creation requests.
> 
>     * ’grantedCodeEnvCreationRequestEmails’ (bool): Email notifications when a code env request is granted.
> 
>     * ’dailyDigestsEmails’ (bool): Daily digest emails.
> 
>     * ’offlineActivityEmails’ (bool): Offline activity summary emails.
> 
>     * ’rememberPositionFlow’ (bool): Remember position in the Flow.
> 
>     * ’loginLogoutNotifications’ (bool): Notifications for login/logout.
> 
>     * ’watchedObjectsEditionsNotifications’ (bool): Notifications for edits on watched objects.
> 
>     * ’objectOnCurrentProjectCreatedDeletedNotifications’ (bool): Notifications for object creation/deletion in the current project.
> 
>     * ’anyObjectOnCurrentProjectEditedNotifications’ (bool): Notifications for any object edit in the current project.
> 
>     * ’watchStarOnCurrentProjectNotifications’ (bool): Notifications for watch/star actions in the current project.
> 
>     * ’otherUsersJobsTasksNotifications’ (bool): Notifications for jobs/tasks from other users.
> 
>     * ’requestAccessNotifications’ (bool): Notifications for access requests.
> 
>     * ’scenarioRunNotifications’ (bool): Notifications for scenario runs.




Return type:
    

list[dict]

Returns:
    

A list of dictionaries, one for each attempted modification, indicating the status. Each dictionary contains the following keys:

  * ’login’ (str): The login of the user that was modified.

  * ’status’ (str): The result of the operation, either ‘SUCCESS’ or ‘FAILURE’.

  * ’error’ (str): The error message if the status is ‘FAILURE’, otherwise empty.




delete_users(_user_logins_ , _allow_self_deletion =False_)
    

Bulk deletes multiple users.

Note: This call requires an API key with admin rights.

Note: this call is not available to Dataiku Cloud users

Parameters:
    

  * **user_logins** (_list_ _[__str_ _]_) – A list of logins for the users to be deleted.

  * **allow_self_deletion** (_bool_) – Allow the use of this function to delete your own user. Warning: this is very dangerous and used recklessly could lead to the deletion of all users/admins.



Return type:
    

list[dict]

Returns:
    

A list of dictionaries, one for each attempted deletion, indicating the status. Each dictionary contains the following keys:

  * ’login’ (str): The login of the user that was deleted.

  * ’status’ (str): The result of the deletion, either ‘SUCCESS’ or ‘FAILURE’.

  * ’error’ (str): The error message if the status is ‘FAILURE’, otherwise empty.




get_own_user()
    

Get a handle to interact with the current user

Returns:
    

A [`dataikuapi.dss.admin.DSSOwnUser`](<users-groups.html#dataikuapi.dss.admin.DSSOwnUser> "dataikuapi.dss.admin.DSSOwnUser") user handle

list_users_activity(_enabled_users_only =False_)
    

List all users activity

Note: this call requires an API key with admin rights

Returns:
    

A list of user activity logs, as a list of [`dataikuapi.dss.admin.DSSUserActivity`](<users-groups.html#dataikuapi.dss.admin.DSSUserActivity> "dataikuapi.dss.admin.DSSUserActivity") if as_objects is True, else as a list of dict

Return type:
    

list of [`dataikuapi.dss.admin.DSSUserActivity`](<users-groups.html#dataikuapi.dss.admin.DSSUserActivity> "dataikuapi.dss.admin.DSSUserActivity") or a list of dict

list_expired_trial_users()
    

List users whose trials have expired :return: A list of users

get_authorization_matrix()
    

Get the authorization matrix for all enabled users and groups

Note: this call requires an API key with admin rights

Returns:
    

The authorization matrix

Return type:
    

A [`dataikuapi.dss.admin.DSSAuthorizationMatrix`](<users-groups.html#dataikuapi.dss.admin.DSSAuthorizationMatrix> "dataikuapi.dss.admin.DSSAuthorizationMatrix") authorization matrix handle

start_resync_users_from_supplier(_logins_)
    

Starts a resync of multiple users from an external supplier (LDAP, Azure AD or custom auth)

Parameters:
    

**logins** (_list_) – list of logins to resync

Returns:
    

a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the sync process

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

start_resync_all_users_from_supplier()
    

Starts a resync of all users from an external supplier (LDAP, Azure AD or custom auth)

Returns:
    

a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the sync process

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

start_fetch_external_groups(_user_source_type_)
    

Fetch groups from external source

Parameters:
    

**user_source_type** – ‘LDAP’, ‘AZURE_AD’ or ‘CUSTOM’

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

Returns:
    

a DSSFuture containing a list of group names

start_fetch_external_users(_user_source_type_ , _login =None_, _email =None_, _group_name =None_)
    

Fetch users from external source filtered by login or group name:
    

  * if login or email is provided, will search for a user with an exact match in the external source (e.g. before login remapping)

  * else,
    
    * if group_name is provided, will search for members of the group in the external source

    * else will search for all users




Parameters:
    

  * **user_source_type** – ‘LDAP’, ‘AZURE_AD’ or ‘CUSTOM’

  * **login** – optional - the login of the user in the external source

  * **email** – optional - the email of the user in the external source

  * **group_name** – optional - the group name of the group in the external source



Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

Returns:
    

a DSSFuture containing a list of ExternalUser

start_provision_users(_user_source_type_ , _users_)
    

Provision users of given source type

Parameters:
    

  * **user_source_type** (_string_) – ‘LDAP’, ‘AZURE_AD’ or ‘CUSTOM’

  * **users** (_list_) – list of user attributes coming form the external source



Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

list_groups()
    

List all groups setup on the DSS instance

Note: this call requires an API key with admin rights

Returns:
    

A list of groups, as an list of dicts

Return type:
    

list of dicts

get_group(_name_)
    

Get a handle to interact with a specific group

Parameters:
    

**name** (_str_) – the name of the desired group

Returns:
    

A [`dataikuapi.dss.admin.DSSGroup`](<users-groups.html#dataikuapi.dss.admin.DSSGroup> "dataikuapi.dss.admin.DSSGroup") group handle

create_group(_name_ , _description =None_, _source_type ='LOCAL'_)
    

Create a group, and return a handle to interact with it

Note: this call requires an API key with admin rights

Parameters:
    

  * **name** (_str_) – the name of the new group

  * **description** (_str_) – (optional) a description of the new group

  * **source_type** – the type of the new group. Admissible values are ‘LOCAL’ and ‘LDAP’



Returns:
    

A [`dataikuapi.dss.admin.DSSGroup`](<users-groups.html#dataikuapi.dss.admin.DSSGroup> "dataikuapi.dss.admin.DSSGroup") group handle

list_connections(_as_type ='dictitems'_)
    

List all connections setup on the DSS instance.

Note

This call requires an API key with admin rights

Parameters:
    

**as_type** (_string_) – how to return the connection. Possible values are “dictitems”, “listitems” and “objects”

Returns:
    

if **as_type** is dictitems, a dict of connection name to [`dataikuapi.dss.admin.DSSConnectionListItem`](<connections.html#dataikuapi.dss.admin.DSSConnectionListItem> "dataikuapi.dss.admin.DSSConnectionListItem"). if **as_type** is listitems, a list of [`dataikuapi.dss.admin.DSSConnectionListItem`](<connections.html#dataikuapi.dss.admin.DSSConnectionListItem> "dataikuapi.dss.admin.DSSConnectionListItem"). if **as_type** is objects, a list of [`dataikuapi.dss.admin.DSSConnection`](<connections.html#dataikuapi.dss.admin.DSSConnection> "dataikuapi.dss.admin.DSSConnection").

Return type:
    

dict or list

list_connections_names(_connection_type_)
    

List all connections names on the DSS instance.

Parameters:
    

**connection_type** (_str_) – Returns only connections with this type. Use ‘all’ if you don’t want to filter.

Returns:
    

the list of connections names

Return type:
    

List[str]

get_connection(_name_)
    

Get a handle to interact with a specific connection

Parameters:
    

**name** (_str_) – the name of the desired connection

Returns:
    

A [`dataikuapi.dss.admin.DSSConnection`](<connections.html#dataikuapi.dss.admin.DSSConnection> "dataikuapi.dss.admin.DSSConnection") connection handle

create_connection(_name_ , _type_ , _params =None_, _usable_by ='ALL'_, _allowed_groups =None_, _description =None_)
    

Create a connection, and return a handle to interact with it

Note: this call requires an API key with admin rights

Parameters:
    

  * **name** – the name of the new connection

  * **type** – the type of the new connection

  * **params** (_dict_) – the parameters of the new connection, as a JSON object (defaults to {})

  * **usable_by** – the type of access control for the connection. Either ‘ALL’ (=no access control) or ‘ALLOWED’ (=access restricted to users of a list of groups)

  * **allowed_groups** (_list_) – when using access control (that is, setting usable_by=’ALLOWED’), the list of names of the groups whose users are allowed to use the new connection (defaults to [])

  * **description** (_str_) – (optional) a description of the new connection



Returns:
    

A [`dataikuapi.dss.admin.DSSConnection`](<connections.html#dataikuapi.dss.admin.DSSConnection> "dataikuapi.dss.admin.DSSConnection") connection handle

list_code_envs(_as_objects =False_)
    

List all code envs setup on the DSS instance

Parameters:
    

**as_objects** (_boolean_) – if True, each returned item will be a `dataikuapi.dss.future.DSSCodeEnv`

Returns:
    

a list of code envs. Each code env is a dict containing at least “name”, “type” and “language”

get_code_env(_env_lang_ , _env_name_)
    

Get a handle to interact with a specific code env

Parameters:
    

  * **env_lang** – the language (PYTHON or R) of the new code env

  * **env_name** – the name of the new code env



Returns:
    

A [`dataikuapi.dss.admin.DSSCodeEnv`](<code-envs.html#dataikuapi.dss.admin.DSSCodeEnv> "dataikuapi.dss.admin.DSSCodeEnv") code env handle

create_internal_code_env(_internal_env_type_ , _python_interpreter =None_, _code_env_version =None_, _wait =True_)
    

Create a Python internal code environment, and return a handle to interact with it.

Note: this call requires an API key with Create code envs or Manage all code envs permission

Example:
    
    
    env_handle = client.create_internal_code_env(internal_env_type="RAG_CODE_ENV", python_interpreter="PYTHON310")
    

Parameters:
    

  * **internal_env_type** (_str_) – the internal env type, can be DEEP_HUB_IMAGE_CLASSIFICATION_CODE_ENV, DEEP_HUB_IMAGE_OBJECT_DETECTION_CODE_ENV, PROXY_MODELS_CODE_ENV, DATABRICKS_UTILS_CODE_ENV, PII_DETECTION_CODE_ENV, HUGGINGFACE_LOCAL_CODE_ENV, RAG_CODE_ENV, DOCUMENT_EXTRACTION_CODE_ENV, DOCUMENT_TEMPLATING_CODE_ENV.

  * **python_interpreter** (_str_) – Python interpreter version, can be PYTHON39, PYTHON310, PYTHON311, PYTHON312 or PYTHON313. If None, DSS will try to select a supported & available interpreter.

  * **code_env_version** (_str_) – Version of the code env. Reserved for future use.

  * **wait** (_bool_) – wait for the code env to be created or return a future



Returns:
    

A [`dataikuapi.dss.admin.DSSCodeEnv`](<code-envs.html#dataikuapi.dss.admin.DSSCodeEnv> "dataikuapi.dss.admin.DSSCodeEnv") code env handle or a dataikuapi.dss.future.DSSFuture if wait is False

create_code_env(_env_lang_ , _env_name_ , _deployment_mode_ , _params =None_, _wait =True_)
    

Create a code env, and return a handle to interact with it

Note: this call requires an API key with Create code envs or Manage all code envs permission

Parameters:
    

  * **env_lang** – the language (PYTHON or R) of the new code env

  * **env_name** – the name of the new code env

  * **deployment_mode** – the type of the new code env

  * **params** – the parameters of the new code env, as a JSON object

  * **wait** (_bool_) – wait for the code env to be created or return a future



Returns:
    

A [`dataikuapi.dss.admin.DSSCodeEnv`](<code-envs.html#dataikuapi.dss.admin.DSSCodeEnv> "dataikuapi.dss.admin.DSSCodeEnv") code env handle

list_code_env_usages()
    

List all usages of a code env in the instance

Returns:
    

a list of objects where the code env is used

create_code_env_from_python_preset(_preset_name_ , _allow_update =True_, _interpreter =None_, _prefix =None_, _wait =True_)
    

list_clusters()
    

List all clusters setup on the DSS instance

Returns:
    

List clusters (name, type, state)

get_cluster(_cluster_id_)
    

Get a handle to interact with a specific cluster

Args:
    

name: the name of the desired cluster

Returns:
    

A [`dataikuapi.dss.admin.DSSCluster`](<clusters.html#dataikuapi.dss.admin.DSSCluster> "dataikuapi.dss.admin.DSSCluster") cluster handle

create_cluster(_cluster_name_ , _cluster_type ='manual'_, _params =None_, _cluster_architecture ='HADOOP'_)
    

Create a cluster, and return a handle to interact with it

Parameters:
    

  * **cluster_name** – the name of the new cluster

  * **cluster_type** – the type of the new cluster

  * **params** – the parameters of the new cluster, as a JSON object

  * **cluster_architecture** – the architecture of the new cluster. ‘HADOOP’ or ‘KUBERNETES’



Returns:
    

A [`dataikuapi.dss.admin.DSSCluster`](<clusters.html#dataikuapi.dss.admin.DSSCluster> "dataikuapi.dss.admin.DSSCluster") cluster handle

list_code_studio_templates(_as_type ='listitems'_)
    

List all code studio templates on the DSS instance

Returns:
    

List of templates (name, type)

get_code_studio_template(_template_id_)
    

Get a handle to interact with a specific code studio template

Parameters:
    

**template_id** (_str_) – the template id of the desired code studio template

Returns:
    

A [`dataikuapi.dss.admin.DSSCodeStudioTemplate`](<code-studios.html#dataikuapi.dss.admin.DSSCodeStudioTemplate> "dataikuapi.dss.admin.DSSCodeStudioTemplate") code studio template handle

list_global_api_keys(_as_type ='listitems'_)
    

List all global API keys set up on the DSS instance

Note

This call requires an API key with admin rights

Note

If the secure API keys feature is enabled, the secret key of the listed API keys will not be present in the returned objects

Parameters:
    

**as_type** (_str_) – How to return the global API keys. Possible values are “listitems” and “objects”

Returns:
    

if as_type=listitems, each key as a [`dataikuapi.dss.admin.DSSGlobalApiKeyListItem`](<other-administration.html#dataikuapi.dss.admin.DSSGlobalApiKeyListItem> "dataikuapi.dss.admin.DSSGlobalApiKeyListItem"). if as_type=objects, each key is returned as a [`dataikuapi.dss.admin.DSSGlobalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSGlobalApiKey> "dataikuapi.dss.admin.DSSGlobalApiKey").

get_global_api_key(_key_)
    

Get a handle to interact with a specific Global API key

Deprecated since version 13.0.0: Use `DSSClient.get_global_api_key_by_id()`. Calling this method with an invalid secret key will now result in an immediate error.

Parameters:
    

**key** (_str_) – the secret key of the API key

Returns:
    

A [`dataikuapi.dss.admin.DSSGlobalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSGlobalApiKey> "dataikuapi.dss.admin.DSSGlobalApiKey") API key handle

get_global_api_key_by_id(_id__)
    

Get a handle to interact with a specific Global API key

Parameters:
    

**id** (_str_) – the id the API key

Returns:
    

A [`dataikuapi.dss.admin.DSSGlobalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSGlobalApiKey> "dataikuapi.dss.admin.DSSGlobalApiKey") API key handle

create_global_api_key(_label =None_, _description =None_, _admin =False_)
    

Create a Global API key, and return a handle to interact with it.

Use `DSSClient.create_global_api_key_with_groups()` to create global API keys that use groups to manage their permissions.

Note

This call requires an API key with admin rights

Note

The secret key of the created API key will always be present in the returned object, even if the secure API keys feature is enabled

Parameters:
    

  * **label** (_str_) – the label of the new API key

  * **description** (_str_) – the description of the new API key

  * **admin** (_boolean_) – has the new API key admin rights (True or False)



Returns:
    

A [`dataikuapi.dss.admin.DSSGlobalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSGlobalApiKey> "dataikuapi.dss.admin.DSSGlobalApiKey") API key handle

create_global_api_key_with_groups(_label =None_, _description =None_, _groups =None_)
    

Create a Global API key, and return a handle to interact with it.

Note

This call requires an API key with admin rights

Note

The secret key of the created API key will always be present in the returned object, even if the secure API keys feature is enabled

Parameters:
    

  * **label** (_str_) – the label of the new API key

  * **description** (_str_) – the description of the new API key

  * **groups** (_list_) – the groups the new API key belongs to



Returns:
    

A [`dataikuapi.dss.admin.DSSGlobalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSGlobalApiKey> "dataikuapi.dss.admin.DSSGlobalApiKey") API key handle

list_personal_api_keys(_as_type ='listitems'_)
    

List all your personal API keys.

Parameters:
    

**as_type** (_str_) – How to return the personal API keys. Possible values are “listitems” and “objects”

Returns:
    

if as_type=listitems, each key as a [`dataikuapi.dss.admin.DSSPersonalApiKeyListItem`](<other-administration.html#dataikuapi.dss.admin.DSSPersonalApiKeyListItem> "dataikuapi.dss.admin.DSSPersonalApiKeyListItem"). if as_type=objects, each key is returned as a [`dataikuapi.dss.admin.DSSPersonalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSPersonalApiKey> "dataikuapi.dss.admin.DSSPersonalApiKey").

get_personal_api_key(_id_)
    

Get a handle to interact with a specific Personal API key.

Parameters:
    

**id** (_str_) – the id of the desired API key

Returns:
    

A [`dataikuapi.dss.admin.DSSPersonalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSPersonalApiKey> "dataikuapi.dss.admin.DSSPersonalApiKey") API key handle

create_personal_api_key(_label =''_, _description =''_, _as_type ='dict'_)
    

Create a Personal API key associated with your user.

Parameters:
    

  * **label** (_str_) – the label of the new API key

  * **description** (_str_) – the description of the new API key

  * **as_type** (_str_) – How to return the personal API keys. Possible values are “dict” and “object”



Returns:
    

if as_type=dict, the new personal API key is returned as a dict. if as_type=object, the new personal API key is returned as a [`dataikuapi.dss.admin.DSSPersonalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSPersonalApiKey> "dataikuapi.dss.admin.DSSPersonalApiKey").

list_all_personal_api_keys(_as_type ='listitems'_)
    

List all personal API keys. Only admin can list all the keys.

Parameters:
    

**as_type** (_str_) – How to return the personal API keys. Possible values are “listitems” and “objects”

Returns:
    

if as_type=listitems, each key as a [`dataikuapi.dss.admin.DSSPersonalApiKeyListItem`](<other-administration.html#dataikuapi.dss.admin.DSSPersonalApiKeyListItem> "dataikuapi.dss.admin.DSSPersonalApiKeyListItem"). if as_type=objects, each key is returned as a [`dataikuapi.dss.admin.DSSPersonalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSPersonalApiKey> "dataikuapi.dss.admin.DSSPersonalApiKey").

create_personal_api_key_for_user(_user_ , _label =''_, _description =''_, _as_type ='object'_)
    

Create a Personal API key associated on behalf of a user. Only admin can create a key for another user.

Parameters:
    

  * **label** (_str_) – the label of the new API key

  * **description** (_str_) – the description of the new API key

  * **user** (_str_) – the id of the user to impersonate

  * **as_type** (_str_) – How to return the personal API keys. Possible values are “dict” and “object”



Returns:
    

if as_type=dict, the new personal API key is returned as a dict. if as_type=object, the new personal API key is returned as a [`dataikuapi.dss.admin.DSSPersonalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSPersonalApiKey> "dataikuapi.dss.admin.DSSPersonalApiKey").

list_meanings()
    

List all user-defined meanings on the DSS instance

Returns:
    

A list of meanings. Each meaning is a dict

Return type:
    

list of dicts

get_meaning(_id_)
    

Get a handle to interact with a specific user-defined meaning

Parameters:
    

**id** (_str_) – the ID of the desired meaning

Returns:
    

A [`dataikuapi.dss.meaning.DSSMeaning`](<meanings.html#dataikuapi.dss.meaning.DSSMeaning> "dataikuapi.dss.meaning.DSSMeaning") meaning handle

create_meaning(_id_ , _label_ , _type_ , _description =None_, _values =None_, _mappings =None_, _pattern =None_, _normalizationMode =None_, _detectable =False_)
    

Create a meaning, and return a handle to interact with it

Note: this call requires an API key with admin rights

Parameters:
    

  * **id** – the ID of the new meaning

  * **type** – the type of the new meaning. Admissible values are ‘DECLARATIVE’, ‘VALUES_LIST’, ‘VALUES_MAPPING’ and ‘PATTERN’

  * **(****optional****)** (_detectable_) – the description of the new meaning

  * **(****optional****)** – when type is ‘VALUES_LIST’, the list of values, or a list of {‘value’:’the value’, ‘color’:’an optional color’}

  * **(****optional****)** – when type is ‘VALUES_MAPPING’, the mapping, as a list of objects with this structure: {‘from’: ‘value_1’, ‘to’: ‘value_a’}

  * **(****optional****)** – when type is ‘PATTERN’, the pattern

  * **(****optional****)** – when type is ‘VALUES_LIST’, ‘VALUES_MAPPING’ or ‘PATTERN’, the normalization mode to use for value matching. One of ‘EXACT’, ‘LOWERCASE’, or ‘NORMALIZED’ (not available for ‘PATTERN’ type). Defaults to ‘EXACT’.

  * **(****optional****)** – whether DSS should consider assigning the meaning to columns set to ‘Auto-detect’. Defaults to False.



Returns:
    

A [`dataikuapi.dss.meaning.DSSMeaning`](<meanings.html#dataikuapi.dss.meaning.DSSMeaning> "dataikuapi.dss.meaning.DSSMeaning") meaning handle

list_logs()
    

List all available log files on the DSS instance This call requires an API key with admin rights

Returns:
    

A list of log file names

get_log(_name_)
    

Get the contents of a specific log file This call requires an API key with admin rights

Parameters:
    

**name** (_str_) – the name of the desired log file (obtained with `list_logs()`)

Returns:
    

The full content of the log file, as a string

log_custom_audit(_custom_type_ , _custom_params =None_)
    

Log a custom entry to the audit trail

Parameters:
    

  * **custom_type** (_str_) – value for customMsgType in audit trail item

  * **custom_params** (_dict_) – value for customMsgParams in audit trail item (defaults to {})




get_global_usage_summary(_with_per_project =False_)
    

Gets a summary of the global usage of this DSS instance (number of projects, datasets, …) :returns: a summary object

get_variables()
    

Deprecated. Use `get_global_variables()`

get_global_variables()
    

Get the DSS instance’s variables, as a Python dictionary

This call requires an API key with admin rights

Returns:
    

A [`dataikuapi.dss.admin.DSSInstanceVariables`](<other-administration.html#dataikuapi.dss.admin.DSSInstanceVariables> "dataikuapi.dss.admin.DSSInstanceVariables") handle

set_variables(_variables_)
    

Deprecated. Use `get_global_variables()` and [`dataikuapi.dss.admin.DSSInstanceVariables.save()`](<other-administration.html#dataikuapi.dss.admin.DSSInstanceVariables.save> "dataikuapi.dss.admin.DSSInstanceVariables.save")

Updates the DSS instance’s variables

This call requires an API key with admin rights

It is not possible to update a single variable, you must set all of them at once. Thus, you should only use a `variables` parameter that has been obtained using `get_variables()`.

Parameters:
    

**variables** (_dict_) – the new dictionary of all variables of the instance

get_resolved_variables(_project_key =None_, _typed =False_)
    

Get a dictionary of resolved variables of the project.

Parameters:
    

  * **project_key** (_str_) – the project key, defaults to the current project if any

  * **typed** (_bool_) – if True, the variable values will be typed in the returned dict, defaults to False



Returns:
    

a dictionary with instance and project variables merged

get_general_settings()
    

Gets a handle to interact with the general settings.

This call requires an API key with admin rights

Returns:
    

a [`dataikuapi.dss.admin.DSSGeneralSettings`](<other-administration.html#dataikuapi.dss.admin.DSSGeneralSettings> "dataikuapi.dss.admin.DSSGeneralSettings") handle

_class _PermissionsPropagationPolicy(_value_)
    

An enumeration.

NONE _ = 'NONE'_
    

READ_ONLY _ = 'READ_ONLY'_
    

ALL _ = 'ALL'_
    

create_project_from_bundle_local_archive(_archive_path_ , _project_folder =None_, _permissions_propagation_policy =PermissionsPropagationPolicy.NONE_)
    

Create a project from a bundle archive. Warning: this method can only be used on an automation node.

Parameters:
    

  * **archive_path** (_string_) – Path on the local machine where the archive is

  * **project_folder** (A [`dataikuapi.dss.projectfolder.DSSProjectFolder`](<project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder> "dataikuapi.dss.projectfolder.DSSProjectFolder")) – the project folder in which the project will be created or None for root project folder

  * **permissions_propagation_policy** (A `PermissionsPropagationPolicy`) – propagate the permissions that were set in the design node to the new project on the automation node (default: False)




create_project_from_bundle_archive(_fp_ , _project_folder =None_)
    

Create a project from a bundle archive (as a file object) Warning: this method can only be used on an automation node.

Parameters:
    

  * **fp** (_string_) – A file-like object pointing to a bundle archive zip

  * **project_folder** (A [`dataikuapi.dss.projectfolder.DSSProjectFolder`](<project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder> "dataikuapi.dss.projectfolder.DSSProjectFolder")) – the project folder in which the project will be created or None for root project folder




prepare_project_import(_f_)
    

Prepares import of a project archive. Warning: this method can only be used on a design node.

Parameters:
    

**fp** (_file-like_) – the input stream, as a file-like object

Returns:
    

a `TemporaryImportHandle` to interact with the prepared import

get_apideployer()
    

Gets a handle to work with the API Deployer

Return type:
    

[`DSSAPIDeployer`](<api-deployer.html#dataikuapi.dss.apideployer.DSSAPIDeployer> "dataikuapi.dss.apideployer.DSSAPIDeployer")

get_projectdeployer()
    

Gets a handle to work with the Project Deployer

Return type:
    

[`DSSProjectDeployer`](<project-deployer.html#dataikuapi.dss.projectdeployer.DSSProjectDeployer> "dataikuapi.dss.projectdeployer.DSSProjectDeployer")

get_unified_monitoring()
    

Gets a handle to work with Unified Monitoring

Return type:
    

[`DSSUnifiedMonitoring`](<unified-monitoring.html#dataikuapi.dss.unifiedmonitoring.DSSUnifiedMonitoring> "dataikuapi.dss.unifiedmonitoring.DSSUnifiedMonitoring")

get_project_standards()
    

Gets a handle to work with Project Standards

Return type:
    

[`DSSProjectStandards`](<project-standards.html#dataikuapi.dss.project_standards.DSSProjectStandards> "dataikuapi.dss.project_standards.DSSProjectStandards")

catalog_index_connections(_connection_names =None_, _all_connections =False_, _indexing_mode ='FULL'_)
    

Triggers an indexing of multiple connections in the data catalog

Parameters:
    

  * **connection_names** (_list_) – list of connections to index, ignored if all_connections=True (defaults to [])

  * **all_connections** (_bool_) – index all connections (defaults to False)




get_scoring_libs_stream()
    

Get the scoring libraries jar required for scoring with model jars that don’t include libraries. You need to close the stream after download. Failure to do so will result in the DSSClient becoming unusable.

Returns:
    

a jar file, as a stream

Return type:
    

file-like

get_auth_info(_with_secrets =False_)
    

Returns various information about the user currently authenticated using this instance of the API client.

This method returns a dict that may contain the following keys (may also contain others):

  * authIdentifier: login for a user, id for an API key

  * groups: list of group names (if context is an user)

  * secrets: list of dicts containing user secrets (if context is an user)




Param:
    

with_secrets boolean: Return user secrets

Returns:
    

a dict

Return type:
    

dict

get_auth_info_from_browser_headers(_headers_dict_ , _with_secrets =False_)
    

Returns various information about the DSS user authenticated by the dictionary of HTTP headers provided in headers_dict.

This is generally only used in webapp backends

This method returns a dict that may contain the following keys (may also contain others):

  * authIdentifier: login for a user, id for an API key

  * groups: list of group names (if context is an user)

  * secrets: list of dicts containing user secrets (if context is an user)




Param:
    

headers_dict dict: Dictionary of HTTP headers

Param:
    

with_secrets boolean: Return user secrets

Returns:
    

a dict

Return type:
    

dict

get_ticket_from_browser_headers(_headers_dict_)
    

Returns a ticket for the DSS user authenticated by the dictionary of HTTP headers provided in headers_dict.

This is only used in webapp backends

This method returns a ticket to use as a X-DKU-APITicket header

Param:
    

headers_dict dict: Dictionary of HTTP headers

Returns:
    

a string

Return type:
    

string

push_base_images()
    

Push base images for Kubernetes container-execution and Spark-on-Kubernetes

apply_kubernetes_namespaces_policies()
    

Apply Kubernetes namespaces policies defined in the general settings

build_cde_plugins_image()
    

Build and Push the image for containerized dss engine (CDE) with plugins

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the build process

install_jupyter_support()
    

Install or reinstall jupyter kernels support for all container configurations

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the build process

remove_jupyter_support()
    

Remove jupyter kernels support for all container configurations

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the build process

get_instance_info()
    

Get global information about the DSS instance

Returns:
    

a `DSSInstanceInfo`

perform_instance_sanity_check(_exclusion_list =[]_, _wait =True_)
    

Run an Instance Sanity Check.

This call requires an API key with admin rights.

Parameters:
    

**exclusion_list** – a string list of codes to exclude in the sanity check, as returned by `get_sanity_check_codes()`

Returns:
    

a [`dataikuapi.dss.utils.DSSInfoMessages`](<utils.html#dataikuapi.dss.utils.DSSInfoMessages> "dataikuapi.dss.utils.DSSInfoMessages") if wait is True, or a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") handle otherwise

Return type:
    

[`dataikuapi.dss.utils.DSSInfoMessages`](<utils.html#dataikuapi.dss.utils.DSSInfoMessages> "dataikuapi.dss.utils.DSSInfoMessages") or [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

get_sanity_check_codes()
    

Return the list of codes that can be generated by the sanity check.

This call requires an API key with admin rights.

Return type:
    

list[str]

get_licensing_status()
    

Returns a dictionary with information about licensing status of this DSS instance

Return type:
    

dict

set_license(_license_)
    

Sets a new licence for DSS

Parameters:
    

**license** – license (content of license file)

Returns:
    

None

get_govern_client()
    

Return the Govern Client handle corresponding to the Dataiku Govern integration settings, or None if not enabled or misconfigured.

This call requires an API key with admin rights.

Returns:
    

a Dataiku Govern client handle or None if not enabled or misconfigured

Return type:
    

`dataikuapi.GovernClient` or None

govern_dss_sync(_project_key =None_)
    

Sync all DSS elements to Govern, or only one DSS project. Returns immediately with a future representing the process done asynchronously.

This call requires an API key with admin rights.

Parameters:
    

**project_key** (_str_) – restricts the sync to one project, identified by the project_key

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the sync process

Return type:
    

[`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

govern_deployer_sync()
    

Sync all Deployer elements to Govern. Returns immediately with a future representing the process done asynchronously.

This call requires an API key with admin rights.

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the sync process

Return type:
    

[`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

get_object_discussions(_project_key_ , _object_type_ , _object_id_)
    

Get a handle to manage discussions on any object

Parameters:
    

  * **project_key** (_str_) – identifier of the project to access

  * **object_type** (_str_) – DSS object type

  * **object_id** (_str_) – DSS object ID



Returns:
    

the handle to manage discussions

Return type:
    

`dataikuapi.discussion.DSSObjectDiscussions`

get_feature_store()
    

Get a handle to interact with the Feature Store.

Returns:
    

a handle on the feature store

Return type:
    

`dataikuapi.feature_store.DSSFeatureStore`

list_workspaces(_as_objects =False_)
    

List the workspaces

Returns:
    

The list of workspaces.

get_workspace(_workspace_key_)
    

Get a handle to interact with a specific workspace

Parameters:
    

**workspace_key** (_str_) – the workspace key of the desired workspace

Returns:
    

A [`dataikuapi.dss.workspace.DSSWorkspace`](<workspaces.html#dataikuapi.dss.workspace.DSSWorkspace> "dataikuapi.dss.workspace.DSSWorkspace") to interact with this workspace

create_workspace(_workspace_key_ , _name_ , _permissions =None_, _description =None_, _color =None_)
    

Create a new workspace and return a workspace handle to interact with it

Parameters:
    

  * **workspace_key** (_str_) – the identifier to use for the workspace. Must be globally unique

  * **name** (_str_) – the display name for the workspace.

  * **permissions** (_[_[_dataikuapi.dss.workspace.DSSWorkspacePermissionItem_](<workspaces.html#dataikuapi.dss.workspace.DSSWorkspacePermissionItem> "dataikuapi.dss.workspace.DSSWorkspacePermissionItem") _]_) – Initial permissions for the workspace (can be modified later).

  * **description** (_str_) – a description for the workspace.

  * **color** (_str_) – The color to use (#RRGGBB format). A random color will be assigned if not specified



Returns:
    

A [`dataikuapi.dss.workspace.DSSWorkspace`](<workspaces.html#dataikuapi.dss.workspace.DSSWorkspace> "dataikuapi.dss.workspace.DSSWorkspace") workspace handle to interact with this workspace

list_data_collections(_as_type ='listitems'_)
    

List the accessible data collections

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems”, “objects” and “dict” (defaults to **listitems**).

Returns:
    

The list of data collections.

Return type:
    

a list of [`dataikuapi.dss.data_collection.DSSDataCollectionListItem`](<data-collections.html#dataikuapi.dss.data_collection.DSSDataCollectionListItem> "dataikuapi.dss.data_collection.DSSDataCollectionListItem") if as_type is “listitems”, a list of [`dataikuapi.dss.data_collection.DSSDataCollection`](<data-collections.html#dataikuapi.dss.data_collection.DSSDataCollection> "dataikuapi.dss.data_collection.DSSDataCollection") if as_type is “objects”, a list of dict if as_type is “dict”

get_data_collection(_id_)
    

Get a handle to interact with a specific data collection

Parameters:
    

**id** (_str_) – the id of the data collection to fetch

Return type:
    

[`dataikuapi.dss.data_collection.DSSDataCollection`](<data-collections.html#dataikuapi.dss.data_collection.DSSDataCollection> "dataikuapi.dss.data_collection.DSSDataCollection")

create_data_collection(_displayName_ , _id =None_, _tags =None_, _description =None_, _color =None_, _permissions =None_)
    

Create a new data collection and return a handle to interact with it

Parameters:
    

  * **displayName** (_str_) – the display name for the data collection.

  * **id** (_str_) – the identifier to use for the data_collection. Must be 8 alphanumerical characters if set, otherwise a random id will be generated.

  * **tags** (_list_ _of_ _str_) – The list of tags to use (defaults to _[]_)

  * **description** (_str_) – a description for the data collection

  * **color** (_str_) – The color to use (#RRGGBB format). A random color will be assigned if not specified

  * **permissions** (a list of `dict`) – Initial permissions for the data collection (can be modified later - current user will always be added as admin).



Returns:
    

Handle of the newly created Data Collection

Return type:
    

[`dataikuapi.dss.data_collection.DSSDataCollection`](<data-collections.html#dataikuapi.dss.data_collection.DSSDataCollection> "dataikuapi.dss.data_collection.DSSDataCollection")

get_messaging_channel(_channel_id_)
    

Get the messaging channel with the corresponding ID

Parameters:
    

**channel_id** – ID of channel as specified Notifications & Integrations UI

Returns:
    

A messaging channel object, such as [`dataikuapi.dss.messaging_channel.DSSMessagingChannel`](<messaging-channels.html#dataikuapi.dss.messaging_channel.DSSMessagingChannel> "dataikuapi.dss.messaging_channel.DSSMessagingChannel"), or a [`dataikuapi.dss.messaging_channel.DSSMailMessagingChannel`](<messaging-channels.html#dataikuapi.dss.messaging_channel.DSSMailMessagingChannel> "dataikuapi.dss.messaging_channel.DSSMailMessagingChannel") for a mail channel

list_messaging_channels(_as_type ='listitems'_, _channel_type =None_, _channel_family =None_)
    

List all available messaging channels

Parameters:
    

  * **as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects” (defaults to **listitems**).

  * **channel_type** (_str_) – a channel type to filter by, e.g. “smtp”, “aws-ses-mail”, “slack” (see `DSSClient.create_messaging_channel()` for the full list of supported types)

  * **channel_family** (_str_) – a str to filter for family of channels with a similar interface - “mail” for all channels that send email-like messages



Returns:
    

A list of messaging channels after the filtering specified, as listitems ([`dataikuapi.dss.messaging_channel.DSSMessagingChannelListItem`](<messaging-channels.html#dataikuapi.dss.messaging_channel.DSSMessagingChannelListItem> "dataikuapi.dss.messaging_channel.DSSMessagingChannelListItem")) or objects ([`dataikuapi.dss.messaging_channel.DSSMessagingChannel`](<messaging-channels.html#dataikuapi.dss.messaging_channel.DSSMessagingChannel> "dataikuapi.dss.messaging_channel.DSSMessagingChannel") or [`dataikuapi.dss.messaging_channel.DSSMailMessagingChannel`](<messaging-channels.html#dataikuapi.dss.messaging_channel.DSSMailMessagingChannel> "dataikuapi.dss.messaging_channel.DSSMailMessagingChannel"))

new_messaging_channel(_type_)
    

Initializes the creation of a new messaging channel. Returns a [`dataikuapi.dss.messaging_channel.DSSMessagingChannelCreator`](<messaging-channels.html#dataikuapi.dss.messaging_channel.DSSMessagingChannelCreator> "dataikuapi.dss.messaging_channel.DSSMessagingChannelCreator") or one of its subclasses to complete the creation of the messaging channel. The creation requires admin privileges.

Parameters:
    

**type** (_str_) – Type of the messaging channel. Can be of one the following: “smtp”, “aws-ses-mail”, “microsoft-graph-mail”, “slack”, “msft-teams”, “google-chat”, “twilio” or “shell”.

Returns:
    

A new DSS Messaging Channel Creator handle

Return type:
    

[`dataikuapi.dss.messaging_channel.DSSMessagingChannelCreator`](<messaging-channels.html#dataikuapi.dss.messaging_channel.DSSMessagingChannelCreator> "dataikuapi.dss.messaging_channel.DSSMessagingChannelCreator")

Usage example:
    
    
    smtp_messaging_channel_creator = client.new_messaging_channel("smtp")
    smtp_messaging_channel_creator.with_id("Some ID")
    smtp_messaging_channel_creator.with_sender("[[email protected]](</cdn-cgi/l/email-protection>)")
    smtp_messaging_channel_creator.with_authorized_domains(["example.com", "example.org", "something.example.com"])
    smtp_messaging_channel_creator.with_login("username")
    smtp_messaging_channel_creator.with_password("password")
    smtp_messaging_channel_creator.with_host("host.example.com")
    smtp_messaging_channel_creator.with_port(443)
    smtp_messaging_channel_creator.with_session_properties([{ "key": "key1", "value": "value1" }, { "key": "key2", "value": "value2" }])
    smtp_messaging_channel = smtp_messaging_channel_creator.create()
    

create_messaging_channel(_channel_type_ , _channel_id =None_, _channel_configuration =None_, _permissions =None_)
    

Create a messaging channel. Requires admin privileges.

We strongly recommend that you use the creator helpers instead of calling this directly. See `DSSClient.new_messaging_channel()`.

Parameters:
    

  * **channel_type** (_str_) – type of the channel type. Can be of one the following: “smtp”, “aws-ses-mail”, “microsoft-graph-mail”, “slack”, “msft-teams”, “google-chat”, “twilio” or “shell”.

  * **channel_id** (_str_) – optional ID of the channel, must be unique. If None or empty a random ID will be generated.

  * **channel_configuration** (_dict_) – 

optional specific configuration for the channel depending on the channel type. Every configuration entry is optional but not provided some may lead to a non-functional messaging channel.

    * ”smtp”, “aws-ses-mail”, “microsoft-graph-mail”:
    
      * ”useCurrentUserAsSender”: True to use the email of the user triggering the action as sender, False otherwise. Has precedence over ‘sender’ property;

      * ”sender”: sender email, use an adhoc provided email if not provided;

      * ”authorizedDomain”: comma-separated list of authorized domains for “To” addresses;

      * ”useSSL”: True to use SSL, False otherwise;

      * ”useTLS”: True to use TLS, False otherwise;

      * ”login”: user login;

      * ”password”: user password;

      * ”host”: host to connect to;

      * ”port”: port to connect to;

      * ”sessionProperties”: Array of dictionaries with “key” and “value” keys set for session extra properties;

      * Additional for “aws-ses-mail”:
    
        * ”accessKey”: AWS access key;

        * ”secretKey”: AWS secret key;

        * ”regionOrEndpoint”: AWS region or custom endpoint.

      * Additional for “microsoft-graph-mail”:
    
        * ”clientId”: Microsoft application ID;

        * ”tenantId”: Microsoft directory ID;

        * ”clientSecret”: Account used to sent mails with this channel. Must be a User Principal Name with a valid Microsoft 365 license.

    * ”slack”:
    
      * ”useProxy”: True to use DSS’s proxy settings to connect, False otherwise;

      * ”mode”: connection mode. Can be “WEBHOOK” or “API”;

      * ”webhookUrl”: webhook URL for “WEBHOOK” mode;

      * ”authorizationToken”: authorization token for “API” mode;

      * ”channel”: Slack channel ID.

    * ”msft-teams”:
    
      * ”useProxy”: True to use DSS’s proxy settings to connect, False otherwise;

      * ”webhookUrl”: webhook URL;

      * ”webhookType”: type of webhook to use. Can be “WORKFLOWS” or “OFFICE365” (legacy).

    * ”google-chat”:
    
      * ”useProxy”: True to use DSS’s proxy settings to connect, False otherwise;

      * ”webhookUrl”: webhook URL;

      * ”webhookKey”: key parameter for the webhook URL (mandatory if not included in the URL);

      * ”webhookToken”: token parameter for the webhook URL (mandatory if not included in the URL).

    * ”twilio”:
    
      * ”useProxy”: True to use DSS’s proxy settings to connect, False otherwise;

      * ”accountSid”: Twilio account SID;

      * ”authToken”: authorization token;

      * ”fromNumber”: Twilio from number.

    * ”shell”:
    
      * ”type”: Type of shell execution. Can be “COMMAND” or “FILE”;

      * ”command”: command to execute. In “FILE” mode this string will pass to the -c switch;

      * ”script”: script content to execute for mode “FILE”.

  * **permissions** (_list_ _[__dict_ _]_) – 

optional list of permissions objects (all users can use the channel if not defined). Can be:

    * { “group”: group_id, canUse: True } to authorize a group to use the channel

    * { “user”: user_login, canUse: True } to authorize a single user to use the channel




Usage example:
    
    
    channel_type = "smtp"
    channel_id = "Some ID"
    sender = "[[email protected]](</cdn-cgi/l/email-protection>)"
    authorized_domains = ["example.com", "example.org", "something.example.com"]
    login = "username"
    password = "password"
    host = "host.example.com"
    port = 587
    session_properties = [{ "key": "key1", "value": "value1" }, { "key": "key2", "value": "value2" }]
    channel_params = {
        "useCurrentUserAsSender": False,
        "sender": sender,
        "authorizedDomain": ",".join(authorized_domains),
        "useSSL": True,
        "useTLS": True,
        "login": login,
        "password": password,
        "host": host,
        "port": port,
        "sessionProperties": session_properties
    }
    client.create_messaging_channel(channel_type, channel_id, channel_params)
    

Returns:
    

The created messaging channel object, such as [`dataikuapi.dss.messaging_channel.DSSMessagingChannel`](<messaging-channels.html#dataikuapi.dss.messaging_channel.DSSMessagingChannel> "dataikuapi.dss.messaging_channel.DSSMessagingChannel"), or a [`dataikuapi.dss.messaging_channel.DSSMailMessagingChannel`](<messaging-channels.html#dataikuapi.dss.messaging_channel.DSSMailMessagingChannel> "dataikuapi.dss.messaging_channel.DSSMailMessagingChannel") for a mail channel

get_data_quality_status()
    

Get the status of data-quality monitored projects, including the count of monitored datasets in Ok/Warning/Error/Empty statuses.

Returns:
    

The dict of data quality monitored project statuses.

Return type:
    

dict with PROJECT_KEY as key

get_sso_settings()
    

Get the Single Sign-On (SSO) settings

Returns:
    

SSO settings

Return type:
    

`dataikuapi.iam.settings.SSOSettings`

get_ldap_settings()
    

Get the LDAP settings

Returns:
    

LDAP settings

Return type:
    

`dataikuapi.iam.settings.LDAPSettings`

get_azure_ad_settings()
    

Get the Azure Active Directory (aka Microsoft Entra ID) settings

Returns:
    

Azure AD settings

Return type:
    

`dataikuapi.iam.settings.AzureADSettings`

get_data_directories_footprint()
    

Gets a handle to work with Data Directories Footprint

Return type:
    

[`dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint`](<footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint")

get_llm_cost_limiting_counters()
    

Gets the LLM cost limiting counters of the instance

Returns:
    

the cost limiting counters

Return type:
    

DSSLLMCostLimitingCounters

new_permission_check()
    

Starts a permission check on a set of DSS objects

Return type:
    

DSSPermissionsCheckRequest

get_enterprise_asset_library()
    

Gets a handle to work with the Enterprise Asset Library

Return type:
    

[`dataikuapi.dss.enterprise_asset_library.DSSEnterpriseAssetLibrary`](<enterprise-asset-library.html#dataikuapi.dss.enterprise_asset_library.DSSEnterpriseAssetLibrary> "dataikuapi.dss.enterprise_asset_library.DSSEnterpriseAssetLibrary")

_class _dataikuapi.dssclient.TemporaryImportHandle(_client_ , _import_id_)
    

execute(_settings =None_)
    

Executes the import with provided settings.

Parameters:
    

**settings** (_dict_) – 

Dict of import settings (defaults to {}). The following settings are available:

  * targetProjectKey (string): Key to import under. Defaults to the original project key

  * remapping (dict): Dictionary of connection, code env and container execution context remapping settings.

> See example of remapping dict:
>         
>         "remapping" : {
>           "connections": [
>             { "source": "src_conn1", "target": "target_conn1" },
>             { "source": "src_conn2", "target": "target_conn2" }
>           ],
>           "codeEnvs" : [
>             { "source": "src_codeenv1", "target": "target_codeenv1" },
>             { "source": "src_codeenv2", "target": "target_codeenv2" }
>           ],
>           "enableContainerExecRemapping": True,
>           "containerExecs" : [
>             { "source": "src_container_exec1", "target": "target_container_exec1" },
>             { "source": "src_container_exec2", "target": "target_container_exec2" }
>           ]
>         }
>         




@warning: You must check the ‘success’ flag

---

## [api-reference/python/cloud]

# Cloud

_class _dataikuapi.launchpad_client.LaunchpadClient(_space_id : str_, _api_key_id : str_, _api_key_secret : str_, _host ='https://api.launchpad-dku.app.dataiku.io/v1'_, _extra_headers : dict | None = None_)
    

Entry point for the Launchpad API client

build_invite(_email : str_, _profile : str_, _groups : List[str] | None = None_) → LaunchpadInvite
    

Get a handle for a new invite

Note

This does not create the invite on the Launchpad, it simply returns an object. See usage example to create the invite on the Launchpad.

Usage example:
    
    
    # Invite a user
    invite = client.build_invite("[[email protected]](</cdn-cgi/l/email-protection>)", "designer", ["designers"])
    client.create_invites([invite])
    

Parameters:
    

  * **email** (_str_) – the email of the invitee to create

  * **profile** (_str_) – the profile of the invitee across Dataiku & Govern nodes

  * **groups** (_Optional_ _[__List_ _[__str_ _]__]_) – the groups of the invitee across Dataiku & Govern nodes. Defaults to `[]`



Returns:
    

An invite object

Return type:
    

LaunchpadInvite

get_invite(_email : str_) → LaunchpadInvite
    

Get a handle to interact with an existing invite on the Cloud space

Important

`read_users` scope is required

Parameters:
    

**email** (_str_) – the email of the desired invite

Returns:
    

An invite object

Return type:
    

LaunchpadInvite

list_invites(_emails : List[str] | None = None_) → List[LaunchpadInvite]
    

List invites on the Cloud space

Important

`read_users` scope is required

Parameters:
    

**emails** (_Optional_ _[__List_ _[__str_ _]__]_) – the emails of the desired users. Defaults to `None` (no filter)

Returns:
    

A list of invite objects

Return type:
    

List[LaunchpadInvite]

create_invites(_invites : List[LaunchpadInvite]_, _fail_all_on_error : bool = False_) → Tuple[List[LaunchpadInvite], List[dict]]
    

Create invites on the Cloud space

Important

`write_users` scope is required

Usage example:
    
    
    # Create multiple invites
    invite_1 = client.build_invite(email_1, "reader")
    invite_2 = client.build_invite(email_2, "designer", ["designers"])
    successes, failures = client.create_invites([invite_1, invite_2])
    

Parameters:
    

  * **invites** (_List_ _[__LaunchpadInvite_ _]_) – the list of invite objects to create

  * **fail_all_on_error** (_bool_) – whether to perform the operation atomically, i.e. if one invite fails, all invites fail. Defaults to `False`



Returns:
    

A Tuple of successes (invite objects) and errors (dicts) objects

Return type:
    

Tuple[List[LaunchpadInvite], List[dict]]

update_invites(_invites : List[LaunchpadInvite]_, _fail_all_on_error =False_) → Tuple[List[LaunchpadInvite], List[dict]]
    

Update invites on the Cloud space

Important

`write_users` scope is required

Usage example:
    
    
    # Update invites based on a group
    invites = client.list_invites()
    invites_to_update = [
        invite
        for invite in invites
        if "my-group" in invite.groups
    ]
    for invite in invites_to_update:
        invite.set_profile("designer")
    successes, failures = client.update_invites(invites_to_update)
    

Parameters:
    

  * **invites** (_List_ _[__LaunchpadInvite_ _]_) – the list of invite objects to update

  * **fail_all_on_error** (_bool_) – whether to perform the operation atomically, i.e. if one update fails, all updates fail. Defaults to `False`



Returns:
    

A Tuple of successes (invite objects) and errors (dicts) objects

Return type:
    

Tuple[List[LaunchpadInvite], List[dict]]

delete_invites(_emails : List[str]_, _fail_all_on_error =False_) → Tuple[List[dict], List[dict]]
    

Delete invites on the Cloud space

Important

`write_users` scope is required

Usage example:
    
    
    # Delete invites older than 7 days
    invites = client.list_invites()
    invites_to_delete = [
        invite.email
        for invite in invites
        if invite.created_on <= datetime.now(timezone.utc) - timedelta(days=7)
    ]
    successes, failures = client.delete_invites(invites_to_delete)
    

Parameters:
    

  * **emails** (_List_ _[__str_ _]_) – the list of emails to delete

  * **fail_all_on_error** (_bool_) – whether to perform the operation atomically, i.e. if one deletion fails, all deletions fail. Defaults to `False`



Returns:
    

A Tuple of successes (dicts) and errors (dicts) objects

Return type:
    

Tuple[List[dict], List[dict]]

get_user(_email : str_) → LaunchpadUser
    

Get a handle to interact with an existing user on the Cloud space

Important

`read_users` scope is required

Parameters:
    

**email** (_str_) – the email of the desired user

Returns:
    

A user object

Return type:
    

LaunchpadUser

list_users(_emails : List[str] | None = None_) → List[LaunchpadUser]
    

List users on the Cloud space

Important

`read_users` scope is required

Parameters:
    

**emails** (_Optional_ _[__List_ _[__str_ _]__]_) – the emails of the desired users. Defaults to `None` (no filter)

Returns:
    

A list of user objects

Return type:
    

List[LaunchpadUser]

update_users(_users : List[LaunchpadUser]_, _fail_all_on_error =False_, _wait_for_propagation =False_) → Tuple[List[LaunchpadUser], List[dict]]
    

Update users on the Cloud space

Important

`write_users` scope is required

Usage example:
    
    
    # Update users based on a group
    users = client.list_users()
    users_to_update = [
        user
        for user in users
        if "my-group" in user.groups
    ]
    for user in users_to_update:
        user.set_profile("designer")
    successes, failures = client.update_users(users_to_update)
    

Parameters:
    

  * **users** (_List_ _[__LaunchpadUser_ _]_) – the list of user objects to update

  * **fail_all_on_error** (_bool_) – whether to perform the operation atomically, i.e. if one update fails, all updates fail. Defaults to `False`

  * **wait_for_propagation** (_bool_) – whether to wait for the changes to propagate to all Dataiku & Govern running nodes. Defaults to `False`



Returns:
    

A Tuple of successes (user objects) and errors (dicts) objects

Return type:
    

Tuple[List[LaunchpadUser], List[dict]]

delete_users(_emails : List[str]_, _fail_all_on_error =False_, _wait_for_propagation =False_) → Tuple[List[dict], List[dict]]
    

Delete multiple users on the Cloud space

Important

`write_users` scope is required

Usage example:
    
    
    # Delete users based on a group
    my_group = client.get_group("my-group")
    successes, failures = client.delete_users(my_group.users)
    

Parameters:
    

  * **emails** (_List_ _[__str_ _]_) – the list of user emails to delete

  * **fail_all_on_error** (_bool_) – whether to perform the operation atomically, i.e. if one deletion fails, all deletions fail. Defaults to `False`

  * **wait_for_propagation** (_bool_) – whether to wait for the changes to propagate to all Dataiku & Govern running nodes. Defaults to `False`



Returns:
    

A Tuple of successes (dicts) and errors (dicts) objects

Return type:
    

Tuple[List[dict], List[dict]]

build_group(_name : str_, _description : str | None = None_, _emails : List[str] | None = None_, _launchpad_permissions : Dict[str, bool] | None = None_, _dataiku_permissions : Dict[str, Dict[str, Any]] | None = None_, _govern_permissions : Dict[str, Dict[str, bool]] | None = None_) → LaunchpadGroup
    

Get a handle for a new group

Note

This does not create the group on the Launchpad, it simply returns an object. See usage example to create the group on the Launchpad.

Usage example:
    
    
    # Create a group
    group = client.build_group("Designers", "Designer group", ["[[email protected]](</cdn-cgi/l/email-protection>)"])
    group.launchpad_permissions = {"mayTurnOnSpace": True}
    group.update_permissions({"mayCreateProjects": True}, node_name="design-0")
    group.save()
    

Parameters:
    

  * **name** (_str_) – the name of the group to create

  * **description** (_Optional_ _[__str_ _]_) – the description of the group to create. Defaults to `None`

  * **emails** (_Optional_ _[__List_ _[__str_ _]__]_) – the emails of the group to create. Defaults to `[]`

  * **launchpad_permissions** (_Optional_ _[__Dict_ _[__str_ _,__bool_ _]__]_) – the launchpad permissions of the group. Defaults to `{}`

  * **dataiku_permissions** (_Optional_ _[__Dict_ _[__str_ _,__Dict_ _[__str_ _,__Any_ _]__]__]_) – the permissions of the group across Dataiku nodes. Defaults to `{}`

  * **govern_permissions** (_Optional_ _[__Dict_ _[__str_ _,__Dict_ _[__str_ _,__bool_ _]__]__]_) – the govern permissions of the group across Govern nodes. Defaults to `{}`



Returns:
    

A group object

Return type:
    

LaunchpadGroup

get_group(_name : str_) → LaunchpadGroup
    

Get a handle to interact with an existing group on the Cloud space

Important

`read_groups` scope is required

Parameters:
    

**name** (_str_) – the name of the desired group

Returns:
    

A group object

Return type:
    

LaunchpadGroup

list_groups(_names : List[str] | None = None_) → List[LaunchpadGroup]
    

List groups setup on the Cloud space

Important

`read_groups` scope is required

Parameters:
    

**names** (_Optional_ _[__List_ _[__str_ _]__]_) – the names of the desired groups. Defaults to `None` (no filter)

Returns:
    

A list of group objects

Return type:
    

List[LaunchpadGroup]

list_profiles() → List[LaunchpadProfile]
    

List profiles on the Cloud space

Important

`read_users` scope is required

Returns:
    

A list of profile objects

Return type:
    

List[LaunchpadProfile]

list_nodes(_type : str | None = None_) → List[LaunchpadNode]
    

List nodes on the Cloud space

Parameters:
    

**type** (_Optional_ _[__str_ _]_) – the type of nodes to list. Defaults to `None` (no filter)

Returns:
    

A list of node objects

Return type:
    

List[LaunchpadNode]

_class _dataikuapi.launchpad.group.LaunchpadGroup(_client : LaunchpadClient_, _name : str_, _id : str | None = None_, _** kwargs_)
    

A group on the Cloud space

Important

Do not instantiate directly, use either `get_group()` or `build_group()`.

Usage example:
    
    
    # Create a group
    group = client.build_group("Designers", "Designer group", ["[[email protected]](</cdn-cgi/l/email-protection>)"])
    group.launchpad_permissions = {"mayTurnOnSpace": True}
    group.update_permissions({"mayCreateProjects": True}, node_type="dataiku")
    group.update_permissions({"mayManageGovern": True}, node_type="govern")
    group.save()
    
    # Get a group
    group = client.get_group("my-group")
    
    # List groups
    groups = client.list_groups()
    

_property _id _: str_
    

The group ID

_property _name _: str_
    

The group name

_property _description _: str_
    

The group description

_property _launchpad_permissions _: Dict[str, bool | Dict[str, bool]]_
    

The group’s launchpad permissions

_property _dataiku_permissions _: Dict[str, Dict[str, bool | Dict[str, bool]]]_
    

The group’s dataiku permissions

_property _govern_permissions _: Dict[str, Dict[str, bool | Dict[str, bool]]]_
    

The group’s govern permissions

_property _accessible_nodes _: Tuple[str, ...]_
    

The group’s accessible nodes

_property _users _: Tuple[str, ...]_
    

The users assigned to this group

grant_node_access(_*_ , _node_type : str | None = None_, _node_name : str | None = None_, _copy_permissions_from_node : str | None = None_) → None
    

Grant access to the specified node type or node name

Note

This grants node access to the group, without giving any permissions (all default to `False` on save). If the group already had access, this will not update the permissions. To update permissions once access is granted, see `update_permissions()`.

Usage example:
    
    
    # Grant access and update permissions for a specific node
    group = client.get_group("my-group")
    print(group.accessible_nodes)
    group.grant_node_access(node_name="design-0")
    group.update_permissions(
        {"mayCreateProjects": True},
        node_name="design-0",
        grant_node_access=False,
    )
    group.save()
    
    # Copy the permissions from an existing node
    group = client.get_group("my-group")
    group.grant_node_access(node_name="automation-0", copy_permissions_from_node="design-0")
    group.save()
    

Parameters:
    

  * **node_type** (_Optional_ _[__str_ _]_) – the node_type to set. When provided, `node_name` should be `None`

  * **node_name** (_Optional_ _[__str_ _]_) – the node_name to set. When provided, `node_type` should be `None`

  * **copy_permissions_from_node** (_Optional_ _[__str_ _]_) – the node name to copy permissions from. Defaults to `None`




update_permissions(_permissions : Dict[str, bool | Dict[str, bool]]_, _*_ , _node_type : str | None = None_, _node_name : str | None = None_, _grant_node_access : bool = True_) → None
    

Update permissions for the specified node type or node name

Note

This will not grant access to new nodes. To do so, see `grant_node_access()`.

Usage example:
    
    
    group = client.get_group("my-group")
    
    # Update permissions for all dataiku nodes
    group.update_permissions({"mayCreateProjects": True}, node_type="dataiku")
    
    # Update permissions for a specific node
    group.update_permissions({"mayCreateProjects": True}, node_name="design-0")
    
    # Update permissions for accessible dataiku nodes
    group.update_permissions(
        {"mayCreateProjects": True},
        node_type="dataiku",
        grant_node_access=False,
    )
    
    group.save()
    

Parameters:
    

  * **permissions** (_dict_) – the permissions to update

  * **node_type** (_Optional_ _[__str_ _]_) – the node_type to set. When provided, `node_name` should be `None`

  * **node_name** (_Optional_ _[__str_ _]_) – the node_name to set. When provided, `node_type` should be `None`

  * **grant_node_access** (_bool_) – whether to grant access and update permissions to nodes matching the criteria, or only update permissions for accessible nodes. Defaults to `True` (grant access)




revoke_node_access(_*_ , _node_type : str | None = None_, _node_name : str | None = None_) → None
    

Revoke access to the specified node type or node name

Note

This revokes node access to the group. If the group was missing access, this will not update anything.

Usage example:
    
    
    group = client.get_group("my-group")
    print(group.accessible_nodes)
    group.revoke_node_access(node_type="automation")
    group.save()
    

Parameters:
    

  * **node_type** (_Optional_ _[__str_ _]_) – the node_type to set. When provided, `node_name` should be `None`

  * **node_name** (_Optional_ _[__str_ _]_) – the node_name to set. When provided, `node_type` should be `None`




add_users(_emails : List[str]_) → None
    

Add the users to the group

Note

If you want to add a user to multiple groups, use `add_groups()`.

Usage example:
    
    
    group = client.get_group("my-group")
    group.add_users(["[[email protected]](</cdn-cgi/l/email-protection>)"])
    group.save()
    

Parameters:
    

**emails** (_List_ _[__str_ _]_) – the emails of the users to add to the group

remove_users(_emails : List[str]_) → None
    

Remove the users from the group

Usage example:
    
    
    group = client.get_group(group_id)
    group.remove_users(["[[email protected]](</cdn-cgi/l/email-protection>)"])
    group.save()
    

Parameters:
    

**emails** (_List_ _[__str_ _]_) – the emails of the users to remove from the group

get_raw() → dict
    

Returns:
    

A dictionary representation of the group

Return type:
    

dict

save(_wait_for_propagation =False_) → None
    

Saves the group

Parameters:
    

**wait_for_propagation** (_bool_) – whether to wait for the changes to propagate to all Dataiku running nodes. Defaults to `False`

delete(_wait_for_propagation =False_) → None
    

Delete the group referenced by this object

Parameters:
    

**wait_for_propagation** (_bool_) – whether to wait for the changes to propagate to all Dataiku running nodes. Defaults to `False`

_class _dataikuapi.launchpad.node.LaunchpadNode(_client : LaunchpadClient_, _name : str_, _type : str_)
    

A node on the Cloud space

Important

Do not instantiate directly, use `list_nodes()`

_property _name _: str_
    

The node name

_property _type _: str_
    

The node type

_class _dataikuapi.launchpad.profile.LaunchpadProfile(_client : LaunchpadClient_, _** kwargs_)
    

A profile on the Cloud space

Important

Do not instantiate directly, use `list_profiles()`.

Usage example:
    
    
    # Get profiles
    profiles = client.list_profiles()
    

_property _name _: str_
    

The profile name

_property _total_seats _: int_
    

The total number of seats allowed for this profile. Returns -1 if unlimited (infinity).

_property _used_seats _: int_
    

The number of seats currently used for this profile

_property _free_seats _: int_
    

The number of seats available for this profile. Returns -1 if unlimited (infinity).

_property _is_trial _: bool_
    

Whether the profile is a trial seat or not

get_raw() → dict
    

Returns:
    

A dictionary representation of the profile

Return type:
    

dict

_class _dataikuapi.launchpad.task.LaunchpadTask(_client : LaunchpadClient_, _task_id : str_)
    

A long-running task on the Launchpad

It allows you to track the state of the task and retrieve its result when it is ready

Usage example:
    
    
    # In this example, create a group, which triggers a task
    group = client.build_group(...)
    group.save(wait_for_propagation=True)  # This will wait for the task to complete before returning
    

Note

This class does not need to be instantiated directly.

A `LaunchpadTask` is usually returned by the API calls that are initiating long-running tasks.

_static _from_resp(_client : LaunchpadClient_, _resp : _BaseResponse_) → LaunchpadTask | None
    

Create a `LaunchpadTask` from the response of an endpoint that initiated a long-running task

Parameters:
    

  * **client** (`LaunchpadClient`) – An api client to connect to the Launchpad

  * **resp** (`_BaseResponse`) – The response of the API call that initiated a long-running task.



Returns:
    

the Launchpad task, if any

Return type:
    

Optional[LaunchpadTask]

wait_for_result(_timeout =0_) → dict | None
    

Wait for the completion of the long-running task, and return its result

Parameters:
    

**timeout** (_int_) – A timeout in seconds. Default value (0) means no timeout

Returns:
    

the result of the task

Return type:
    

Optional[dict]

Raises:
    

  * **DataikuTaskException** – if the task failed to complete

  * **DataikuTaskTimeoutException** – if the task failed to complete before the specified timeout




_class _dataikuapi.launchpad.user.LaunchpadInvite(_client : LaunchpadClient_, _email : str_, _id : str | None = None_, _** kwargs_)
    

An invite on the Cloud space

Important

Do not instantiate directly, use either `get_invite()` or `create_invites()`.

Usage example:
    
    
    # Create an invite
    invite = client.build_invite("[[email protected]](</cdn-cgi/l/email-protection>)", "designer")
    client.create_invites([invite])
    
    # Get an invite
    invite = client.get_invite("[[email protected]](</cdn-cgi/l/email-protection>)")
    
    # List invites
    invites = client.list_invites()
    

set_profile(_name : str_, _** kwargs_) → None
    

Set the user’s profile

Usage example:
    
    
    # Update user profile
    invite = client.get_invite("[[email protected]](</cdn-cgi/l/email-protection>)")
    invite.set_profile("designer")
    client.update_invites([invite])
    

Parameters:
    

  * **name** (_str_) – name of the user profile to set

  * **kwargs** (_Any_) – additional keyword arguments




add_groups(_groups : List[str]_) → None
    

Add the user to the specified groups

Usage example:
    
    
    invite = client.get_invite("[[email protected]](</cdn-cgi/l/email-protection>)")
    invite.add_groups(["designers"])
    client.update_invites([invite])
    

Parameters:
    

**groups** (_List_ _[__str_ _]_) – the groups to add the user to

remove_groups(_groups : List[str]_) → None
    

Remove the user from the specified groups

Usage example:
    
    
    invite = client.get_invite("[[email protected]](</cdn-cgi/l/email-protection>)")
    invite.remove_groups(["designers"])
    client.update_invites([invite])
    

Parameters:
    

**groups** (_List_ _[__str_ _]_) – the groups to remove the user from

_class _dataikuapi.launchpad.user.LaunchpadUser(_client : LaunchpadClient_, _email : str_, _id : str | None = None_, _** kwargs_)
    

A user on the Cloud space

Important

Do not instantiate directly, use `get_user()`.

Usage example:
    
    
    # Get a user
    user = client.get_user("[[email protected]](</cdn-cgi/l/email-protection>)")
    
    # List users
    users = client.list_users()
    

_property _is_owner _: bool_
    

Whether the user is the owner of the space

set_profile(_name : str_, _is_trial : bool = False_, _** kwargs_) → None
    

Set the user’s profile

Usage example:
    
    
    # Update user profile
    user = client.get_user("[[email protected]](</cdn-cgi/l/email-protection>)")
    user.set_profile("designer")
    client.update_users([user])
    
    # Start a trial seat
    user = client.get_user("[[email protected]](</cdn-cgi/l/email-protection>)")
    user.set_profile("designer", is_trial=True)
    client.update_users([user])
    

Parameters:
    

  * **name** (_str_) – name of the user profile to set

  * **is_trial** (_Optional_ _[__bool_ _]_) – whether the user is a trial user. Defaults to `False`

  * **kwargs** (_Any_) – additional keyword arguments




add_groups(_groups : List[str]_) → None
    

Add the user to the specified groups

Note

If you want to add multiple users to a group, use `add_users()`.

Usage example:
    
    
    user = client.get_user("[[email protected]](</cdn-cgi/l/email-protection>)")
    user.add_groups(["designers"])
    client.update_users([user])
    

Parameters:
    

**groups** (_List_ _[__str_ _]_) – the groups to add the user to

remove_groups(_groups : List[str]_) → None
    

Remove the user from the specified groups

Usage example:
    
    
    user = client.get_user("[[email protected]](</cdn-cgi/l/email-protection>)")
    user.remove_groups(["designers"])
    client.update_users([user])
    

Parameters:
    

**groups** (_List_ _[__str_ _]_) – the groups to remove the user from

---

## [api-reference/python/clusters]

# Clusters

For usage information and examples, see [Clusters](<../../concepts-and-examples/clusters.html>)

_class _dataikuapi.dss.admin.DSSCluster(_client_ , _cluster_id_)
    

A handle to interact with a cluster on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_cluster()`](<client.html#dataikuapi.DSSClient.get_cluster> "dataikuapi.DSSClient.get_cluster") instead.

delete()
    

Deletes the cluster.

Important

This does not previously stop it.

get_settings()
    

Get the cluster’s settings. This includes opaque data for the cluster if this is a started managed cluster.

The returned object can be used to save settings.

Returns:
    

a `DSSClusterSettings` object to interact with cluster settings

Return type:
    

`DSSClusterSettings`

get_definition()
    

Get the cluster’s definition. This includes opaque data for the cluster if this is a started managed cluster.

Caution

Deprecated, use `get_settings()`

Returns:
    

the definition of the cluster as a dict. For clusters from plugin components, the settings of the cluster are in a **params** field.

Return type:
    

dict

set_definition(_cluster_)
    

Set the cluster’s definition. The definition should come from a call to the get_definition() method.

Caution

Deprecated, use `DSSClusterSettings.save()`

Important

You should only `set_definition()` using an object that you obtained through `get_definition()`, not create a new dict.

Parameters:
    

**cluster** (_dict_) – a cluster definition

Returns:
    

the updated cluster definition

Return type:
    

dict

get_status()
    

Get the cluster’s status and usage

Returns:
    

The cluster status, as a `DSSClusterStatus` object

Return type:
    

`DSSClusterStatus`

start()
    

Starts or attaches the cluster

Caution

This operation is only valid for a managed cluster.

stop(_terminate =True_, _force_stop =False_)
    

Stops or detaches the cluster

This operation is only valid for a managed cluster.

Parameters:
    

  * **terminate** (_boolean_) – whether to delete the cluster after stopping it

  * **force_stop** (_boolean_) – whether to try to force stop the cluster, useful if DSS expects the cluster to already be stopped




run_kubectl(_args_)
    

Runs an arbitrary kubectl command on the cluster.

Caution

This operation is only valid for a Kubernetes cluster.

Note

This call requires an API key with DSS instance admin rights

Parameters:
    

**args** (_string_) – the arguments to pass to kubectl (without the “kubectl”)

Returns:
    

a dict containing the return value, standard output, and standard error of the command

Return type:
    

dict

delete_finished_jobs(_delete_failed =False_, _namespace =None_, _label_filter =None_, _dry_run =False_)
    

Runs a kubectl command to delete finished jobs.

Caution

This operation is only valid for a Kubernetes cluster.

Parameters:
    

  * **delete_failed** (_boolean_) – if True, delete both completed and failed jobs, otherwise only delete completed jobs

  * **namespace** (_string_) – the namespace in which to delete the jobs, if None, uses the namespace set in kubectl’s current context

  * **label_filter** (_string_) – delete only jobs matching a label filter

  * **dry_run** (_boolean_) – if True, execute the command as a “dry run”



Returns:
    

a dict containing whether the deletion succeeded, a list of deleted job names, and debug info for the underlying kubectl command

Return type:
    

dict

delete_finished_pods(_namespace =None_, _label_filter =None_, _dry_run =False_)
    

Runs a kubectl command to delete finished (succeeded and failed) pods.

Caution

This operation is only valid for a Kubernetes cluster.

Parameters:
    

  * **namespace** (_string_) – the namespace in which to delete the pods, if None, uses the namespace set in kubectl’s current context

  * **label_filter** (_string_) – delete only pods matching a label filter

  * **dry_run** (_boolean_) – if True, execute the command as a “dry run”



Returns:
    

a dict containing whether the deletion succeeded, a list of deleted pod names, and debug info for the underlying kubectl command

Return type:
    

dict

delete_all_pods(_namespace =None_, _label_filter =None_, _dry_run =False_)
    

Runs a kubectl command to delete all pods.

Caution

This operation is only valid for a Kubernetes cluster.

Parameters:
    

  * **namespace** (_string_) – the namespace in which to delete the pods, if None, uses the namespace set in kubectl’s current context

  * **label_filter** (_string_) – delete only pods matching a label filter

  * **dry_run** (_boolean_) – if True, execute the command as a “dry run”



Returns:
    

a dict containing whether the deletion succeeded, a list of deleted pod names, and debug info for the underlying kubectl command

Return type:
    

dict

_class _dataikuapi.dss.admin.DSSClusterSettings(_client_ , _cluster_id_ , _settings_)
    

The settings of a cluster.

Important

Do not instantiate directly, use `DSSCluster.get_settings()` instead.

get_raw()
    

Gets all settings as a raw dictionary.

Changes made to the returned object will be reflected when saving.

Fields that can be updated:

>   * **permissions** , **usableByAll** , **owner**
> 
>   * **params**
> 
> 


Returns:
    

reference to the raw settings, not a copy. See `DSSCluster.get_definition()`

Return type:
    

dict

get_plugin_data()
    

Get the opaque data returned by the cluster’s start.

Caution

You should generally not modify this

Returns:
    

the data stored by the plugin in the cluster, None if the cluster is not created by a plugin

Return type:
    

dict

save()
    

Saves back the settings to the cluster

_class _dataikuapi.dss.admin.DSSClusterStatus(_client_ , _cluster_id_ , _status_)
    

The status of a cluster.

Important

Do not instantiate directly, use `DSSCluster.get_status()` instead.

get_raw()
    

Gets the whole status as a raw dictionary.

Returns:
    

status information, as a dict. The current state of the cluster is in a **state** field, with ossible values: NONE, STARTING, RUNNING, STOPPING

Return type:
    

dict

---

## [api-reference/python/code-envs]

# Code envs

For usage information and examples, see [Code envs](<../../concepts-and-examples/code-envs.html>)

_class _dataikuapi.dss.admin.DSSCodeEnv(_client_ , _env_lang_ , _env_name_)
    

A code env on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_code_env()`](<client.html#dataikuapi.DSSClient.get_code_env> "dataikuapi.DSSClient.get_code_env") instead.

delete(_wait =True_)
    

Delete the code env

Note

This call requires an API key with Manage all code envs permission

Parameters:
    

**wait** (_bool_) – wait for the code env to be deleted or return a future

get_definition()
    

Get the code env’s definition

Caution

Deprecated, use `get_settings()` instead

Note

This call requires an API key with Create code envs or Manage all code envs permission

Returns:
    

the code env definition

Return type:
    

dict

set_definition(_env_)
    

Set the code env’s definition. The definition should come from a call to `get_definition()`

Caution

Deprecated, use `get_settings()` then `DSSDesignCodeEnvSettings.save()` or `DSSAutomationCodeEnvSettings.save()` instead

Fields that can be updated in design node:

  * env.permissions, env.usableByAll, env.desc.owner

  * env.specCondaEnvironment, env.specPackageList, env.externalCondaEnvName, env.desc.installCorePackages, env.desc.corePackagesSet, env.desc.installJupyterSupport, env.desc.yarnPythonBin, env.desc.yarnRBin env.desc.envSettings, env.desc.allContainerConfs, env.desc.containerConfs, env.desc.allSparkKubernetesConfs, env.desc.sparkKubernetesConfs




Fields that can be updated in automation node (where {version} is the updated version):

  * env.permissions, env.usableByAll, env.owner, env.envSettings

  * env.{version}.specCondaEnvironment, env.{version}.specPackageList, env.{version}.externalCondaEnvName, env.{version}.desc.installCorePackages, env.{version}.corePackagesSet, env.{version}.desc.installJupyterSupport env.{version}.desc.yarnPythonBin, env.{version}.desc.yarnRBin, env.{version}.desc.allContainerConfs, env.{version}.desc.containerConfs, env.{version}.desc.allSparkKubernetesConfs, env.{version}.{version}.desc.sparkKubernetesConfs




Note

This call requires an API key with Create code envs or Manage all code envs permission

Important

You should only `set_definition()` using an object that you obtained through `get_definition()`, not create a new dict.

Parameters:
    

**data** (_dict_) – a code env definition

Returns:
    

the updated code env definition

Return type:
    

dict

get_version_for_project(_project_key_)
    

Resolve the code env version for a given project

Note

Version will only be non-empty for versioned code envs actually used by the project

Parameters:
    

**project_key** (_string_) – project to get the version for

Returns:
    

the code env version full reference for the version of the code env that the project use, as a dict. The dict should contains a **version** field holding the identifier of the version and a **bundleId** field for the identifier of the active bundle in the project.

Return type:
    

dict

get_settings()
    

Get the settings of this code env.

Important

You must use `DSSCodeEnvSettings.save()` on the returned object to make your changes effective on the code env.
    
    
    # Example: setting the required packagd
    codeenv = client.get_code_env("PYTHON", "code_env_name")
    settings = codeenv.get_settings()
    settings.set_required_packages("dash==2.0.0", "bokeh<2.0")
    settings.save()
    # then proceed to update_packages()
    

Return type:
    

`DSSDesignCodeEnvSettings` or `DSSAutomationCodeEnvSettings`

set_jupyter_support(_active_ , _wait =True_)
    

Update the code env jupyter support

Note

This call requires an API key with Create code envs or Manage all code envs permission

Parameters:
    

  * **active** (_boolean_) – True to activate jupyter support, False to deactivate

  * **wait** (_bool_) – wait for the code env update or return a future




update_packages(_force_rebuild_env =False_, _version =None_, _wait =True_)
    

Update the code env packages so that it matches its spec

Note

This call requires an API key with Create code envs or Manage all code envs permission

Parameters:
    

  * **force_rebuild_env** (_boolean_) – whether to rebuild the code env from scratch

  * **version** (_boolean_) – version to rebuild (applies only to version code envs on automation nodes)

  * **wait** (_bool_) – wait for the code env update or return a future



Returns:
    

list of messages collected during the operation. Fields are:

  * **anyMessage** : whether there is at least 1 message

  * **success** , **warning** , **error** and **fatal** : whether there is at least one message of the corresponding category

  * **messages** : list of messages. Each message is a dict, with at least **severity** and **message** sufields.




Return type:
    

dict

update_images(_env_version =None_, _wait =True_)
    

Rebuild the docker image of the code env

Note

This call requires an API key with admin rights

Parameters:
    

  * **env_version** (_string_) – (optional) version of the code env. Applies only to versioned code envs.

  * **wait** (_bool_) – wait for the images to be rebuilt or return a future



Returns:
    

list of messages collected during the operation. Fields are:

  * **anyMessage** : whether there is at least 1 message

  * **success** , **warning** , **error** and **fatal** : whether there is at least one message of the corresponding category

  * **messages** : list of messages. Each message is a dict, with at least **severity** and **message** sufields.




Return type:
    

dict

list_usages()
    

List usages of the code env in the instance

Returns:
    

a list of objects where the code env is used. Each usage has is a dict with at least:

  * **envUsage** : type of usage. Possible values: PROJECT, RECIPE, NOTEBOOK, PLUGIN, SCENARIO, SCENARIO_STEP, SCENARIO_TRIGGER, DATASET_METRIC, DATASET_CHECK, DATASET, WEBAPP, REPORT, API_SERVICE_ENDPOINT, SAVED_MODEL, MODEL, CODE_STUDIO_TEMPLATE

  * **projectKey** and **objectId** : identifier of the object where the code env is used




Return type:
    

list[dict]

list_logs()
    

List logs of the code env in the instance

Returns:
    

a list of log descriptions. Each log description as a dict with at least a **name** field for the name of the log file.

Return type:
    

list[dict]

get_log(_log_name_)
    

Get the logs of the code env

Parameters:
    

**log_name** (_string_) – name of the log to fetch

Returns:
    

the raw log

Return type:
    

string

_class _dataikuapi.dss.admin.DSSDesignCodeEnvSettings(_codeenv_ , _settings_)
    

Base settings class for a DSS code env on a design node.

Important

Do not instantiate directly, use `DSSCodeEnv.get_settings()` instead.

Use `save()` to save your changes

get_raw()
    

Get the raw code env settings

The structure depends on the type of code env. The data consists of the definition as it is persisted on disk, the lists of requested packages and resource script (if relevant).

Returns:
    

code env settings

Return type:
    

dict

add_container_runtime_addition(_container_runtime_addition_)
    

Add a container runtime addition to the code env settings. Valid values for the container_runtime_addition are: * SYSTEM_LEVEL_CUDA_112_CUDNN_811 * SYSTEM_LEVEL_CUDA_122_CUDNN_897 * CUDA_SUPPORT_FOR_TORCH2_WITH_PYPI_NVIDIA_PACKAGES * BASIC_GPU_ENABLING * PYTHON36_SUPPORT * PYTHON37_SUPPORT * PYTHON38_SUPPORT

Parameters:
    

**container_runtime_addition** (_dict_) – a dict with the container runtime addition definition

built_for_all_spark_kubernetes_confs()
    

Whether the code env creates an image for each managed Spark over Kubernetes config

_property _env_lang
    

Get the language of the code env

Returns:
    

a language (possible values: PYTHON, R)

Return type:
    

string

_property _env_name
    

Get the name of the code env

Return type:
    

string

get_built_container_confs()
    

Get the list of container configs for which the code env builds an image (if not all)

Returns:
    

a list of container configuration names

Return type:
    

list[string]

get_built_for_all_container_confs()
    

Whether the code env creates an image for each container config

Return type:
    

boolean

get_built_spark_kubernetes_confs()
    

Get the list of managed Spark over Kubernetes configs for which the code env builds an image (if not all)

Returns:
    

a list of spark configuration names

Return type:
    

list[string]

get_cache_busting_location()
    

Get the location of the cache busting statement for the code env image

Returns:
    

the location of the cache busting statement (defaults to ‘AFTER_START_DOCKERFILE’)

Return type:
    

string

get_container_runtime_additions()
    

Get the list of container runtime additions for the code env

Returns:
    

a list of container runtime additions, each addition is a dict with at least a **type** field

Return type:
    

list[dict]

get_dockerfile_fragment(_location_)
    

Get the fragment inserted into the code env image Dockerfile at the specified location

Parameters:
    

**location** (_string_) – the location of the fragment in the Dockerfile

Returns:
    

the Dockerfile fragment, or an empty string if no fragment is set for this location

Return type:
    

string

get_required_conda_spec(_as_list =False_)
    

Get the list of required conda packages, as a single string

Parameters:
    

**as_list** (_boolean_) – if True, return the spec as a list of lines; if False, return as a single multiline string

Returns:
    

a list of packages specifications

Return type:
    

list[string] or string

get_required_packages(_as_list =False_)
    

Get the list of required packages, as a single string

Parameters:
    

**as_list** (_boolean_) – if True, return the spec as a list of lines; if False, return as a single multiline string

Returns:
    

a list of packages specifications

Return type:
    

list[string] or string

save()
    

Save the changes to the code env’s settings

set_built_container_confs(_* configs_, _** kwargs_)
    

Set the list of container configs for which the code env builds an image

Parameters:
    

  * **all** (_boolean_) – if True, an image is built for each config

  * **configs** (_list_ _[__string_ _]_) – list of configuration names to build images for




set_built_spark_kubernetes_confs(_* configs_, _** kwargs_)
    

Set the list of managed Spark over Kubernetes configs for which the code env builds an image

Parameters:
    

  * **all** (_boolean_) – if True, an image is built for each config

  * **configs** (_list_ _[__string_ _]_) – list of configuration names to build images for




set_cache_busting_location(_container_cache_busting_location ='AFTER_START_DOCKERFILE'_)
    

Set the location of the cache busting statement for the code env image Valid values are: * BEGINNING * AFTER_START_DOCKERFILE * AFTER_PACKAGES * AFTER_AFTER_PACKAGES_DOCKERFILE * END * NONE

Parameters:
    

**location** (_string_) – the location of the cache busting statement (defaults to ‘AFTER_START_DOCKERFILE’)

set_dockerfile_fragment(_dockerfile_fragment_ , _location_)
    

Set a fragment to insert into the code env image Dockerfile at a specific location Valid locations are: * dockerfileAtStart * dockerfileBeforePackages * dockerfileAfterCondaPackages * dockerfileAfterPackages * dockerfileAtEnd

Parameters:
    

  * **dockerfile_fragment** (_string_) – the Dockerfile fragment to insert

  * **location** (_string_) – the location of the provided fragment in the Dockerfile




set_required_conda_spec(_* spec_)
    

Set the list of required conda packages

Parameters:
    

**spec** (_list_ _[__string_ _]_) – a list of packages specifications

set_required_packages(_* packages_)
    

Set the list of required packages

Parameters:
    

**packages** (_list_ _[__string_ _]_) – a list of packages specifications

_class _dataikuapi.dss.admin.DSSAutomationCodeEnvSettings(_codeenv_ , _settings_)
    

Base settings class for a DSS code env on an automation node.

Important

Do not instantiate directly, use `DSSCodeEnv.get_settings()` instead.

Use `save()` to save your changes

get_raw()
    

Get the raw code env settings

The structure depends on the type of code env. The data consists of the definition as it is persisted on disk, and the identifiers of the versions of the code env, or the spec of the unique version if the code env is not versioned. To access the lists of requested packages or resource scripts. Use `get_version()`.

Returns:
    

code env settings

Return type:
    

dict

get_version(_version_id =None_)
    

Get a specific code env version (for versioned envs) or the single version

Parameters:
    

**version_id** (_string_) – for versioned code env, identifier of the desired version

Returns:
    

the settings of a code env version

Return type:
    

`DSSAutomationCodeEnvVersionSettings`

add_container_runtime_addition(_container_runtime_addition_)
    

Add a container runtime addition to the code env settings. Valid values for the container_runtime_addition are: * SYSTEM_LEVEL_CUDA_112_CUDNN_811 * SYSTEM_LEVEL_CUDA_122_CUDNN_897 * CUDA_SUPPORT_FOR_TORCH2_WITH_PYPI_NVIDIA_PACKAGES * BASIC_GPU_ENABLING * PYTHON36_SUPPORT * PYTHON37_SUPPORT * PYTHON38_SUPPORT

Parameters:
    

**container_runtime_addition** (_dict_) – a dict with the container runtime addition definition

built_for_all_spark_kubernetes_confs()
    

Whether the code env creates an image for each managed Spark over Kubernetes config

_property _env_lang
    

Get the language of the code env

Returns:
    

a language (possible values: PYTHON, R)

Return type:
    

string

_property _env_name
    

Get the name of the code env

Return type:
    

string

get_built_container_confs()
    

Get the list of container configs for which the code env builds an image (if not all)

Returns:
    

a list of container configuration names

Return type:
    

list[string]

get_built_for_all_container_confs()
    

Whether the code env creates an image for each container config

Return type:
    

boolean

get_built_spark_kubernetes_confs()
    

Get the list of managed Spark over Kubernetes configs for which the code env builds an image (if not all)

Returns:
    

a list of spark configuration names

Return type:
    

list[string]

get_cache_busting_location()
    

Get the location of the cache busting statement for the code env image

Returns:
    

the location of the cache busting statement (defaults to ‘AFTER_START_DOCKERFILE’)

Return type:
    

string

get_container_runtime_additions()
    

Get the list of container runtime additions for the code env

Returns:
    

a list of container runtime additions, each addition is a dict with at least a **type** field

Return type:
    

list[dict]

get_dockerfile_fragment(_location_)
    

Get the fragment inserted into the code env image Dockerfile at the specified location

Parameters:
    

**location** (_string_) – the location of the fragment in the Dockerfile

Returns:
    

the Dockerfile fragment, or an empty string if no fragment is set for this location

Return type:
    

string

save()
    

Save the changes to the code env’s settings

set_built_container_confs(_* configs_, _** kwargs_)
    

Set the list of container configs for which the code env builds an image

Parameters:
    

  * **all** (_boolean_) – if True, an image is built for each config

  * **configs** (_list_ _[__string_ _]_) – list of configuration names to build images for




set_built_spark_kubernetes_confs(_* configs_, _** kwargs_)
    

Set the list of managed Spark over Kubernetes configs for which the code env builds an image

Parameters:
    

  * **all** (_boolean_) – if True, an image is built for each config

  * **configs** (_list_ _[__string_ _]_) – list of configuration names to build images for




set_cache_busting_location(_container_cache_busting_location ='AFTER_START_DOCKERFILE'_)
    

Set the location of the cache busting statement for the code env image Valid values are: * BEGINNING * AFTER_START_DOCKERFILE * AFTER_PACKAGES * AFTER_AFTER_PACKAGES_DOCKERFILE * END * NONE

Parameters:
    

**location** (_string_) – the location of the cache busting statement (defaults to ‘AFTER_START_DOCKERFILE’)

set_dockerfile_fragment(_dockerfile_fragment_ , _location_)
    

Set a fragment to insert into the code env image Dockerfile at a specific location Valid locations are: * dockerfileAtStart * dockerfileBeforePackages * dockerfileAfterCondaPackages * dockerfileAfterPackages * dockerfileAtEnd

Parameters:
    

  * **dockerfile_fragment** (_string_) – the Dockerfile fragment to insert

  * **location** (_string_) – the location of the provided fragment in the Dockerfile




_class _dataikuapi.dss.admin.DSSAutomationCodeEnvVersionSettings(_codeenv_settings_ , _version_settings_)
    

Base settings class for a DSS code env version on an automation node.

Important

Do not instantiate directly, use `DSSAutomationCodeEnvSettings.get_version()` instead.

Use `save()` on the `DSSAutomationCodeEnvSettings` to save your changes

get_raw()
    

Get the raw code env version settings

The structure depends on the type of code env. The dict contains a **versionId** field, and the definition of the code env requirements.

Returns:
    

code env settings

Return type:
    

dict

get_required_conda_spec(_as_list =False_)
    

Get the list of required conda packages, as a single string

Parameters:
    

**as_list** (_boolean_) – if True, return the spec as a list of lines; if False, return as a single multiline string

Returns:
    

a list of packages specifications

Return type:
    

list[string] or string

get_required_packages(_as_list =False_)
    

Get the list of required packages, as a single string

Parameters:
    

**as_list** (_boolean_) – if True, return the spec as a list of lines; if False, return as a single multiline string

Returns:
    

a list of packages specifications

Return type:
    

list[string] or string

set_required_conda_spec(_* spec_)
    

Set the list of required conda packages

Parameters:
    

**spec** (_list_ _[__string_ _]_) – a list of packages specifications

set_required_packages(_* packages_)
    

Set the list of required packages

Parameters:
    

**packages** (_list_ _[__string_ _]_) – a list of packages specifications

---

## [api-reference/python/code-studios]

# Code Studios

For usage information and examples, please see [Code Studios](<../../concepts-and-examples/code-studios.html>).

_class _dataikuapi.dss.codestudio.DSSCodeStudioObject(_client_ , _project_key_ , _code_studio_id_)
    

A handle to manage a code studio in a project

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.get_code_studio()`](<projects.html#dataikuapi.dss.project.DSSProject.get_code_studio> "dataikuapi.dss.project.DSSProject.get_code_studio") or [`dataikuapi.dss.project.DSSProject.create_code_studio()`](<projects.html#dataikuapi.dss.project.DSSProject.create_code_studio> "dataikuapi.dss.project.DSSProject.create_code_studio") instead

delete()
    

Delete the code studio

get_settings()
    

Get the code studio’s definition

Usage example
    
    
    # list code studios of some user
    for code_studio in project.list_code_studios(as_type="objects"):
        settings = code_studio.get_settings()
        if settings.owner == 'the_user_login':
            print("User owns code studio %s from template %s" % (settings.name, settings.template_id))
    

Returns:
    

a handle to inspect the code studio definition

Return type:
    

`dataikuapi.dss.codestudio.DSSCodeStudioObjectSettings`

get_status()
    

Get the code studio’s state

Usage example
    
    
    # print list of currently running code studios
    for code_studio in project.list_code_studios(as_type="objects"):
        status = code_studio.get_status()
        if status.state == 'RUNNING':
            settings = code_studio.get_settings()
            print("Code studio %s from template %s is running" % (settings.name, settings.template_id))
    

Returns:
    

a handle to inspect the code studio state

Return type:
    

`dataikuapi.dss.codestudio.DSSCodeStudioObjectStatus`

stop()
    

Stop a running code studio

Returns:
    

a future to wait on the stop, or None if already stopped

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

restart()
    

Start or restart a code studio

Returns:
    

a future to wait on the start

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

check_conflicts(_zone_)
    

Checks whether the files in a zone of the code studio have conflicting changes with what the DSS instance has.

Usage example
    
    
    # stop a code studio if there's no conflict in any zone
    status = code_studio.get_status()
    conflict_count = 0
    for zone in status.get_zones(as_type="names"):
        conflicts = code_studio.check_conflicts(zone)
        conflict_count += len(conflicts.added)
        conflict_count += len(conflicts.modified)
        conflict_count += len(conflicts.deleted)
    if conflict_count == 0:
        code_studio.stop().wait_for_result()
    

Parameters:
    

**zone** (_string_) – name of the zone to check (see `dataikuapi.dss.codestudio.DSSCodeStudioObjectStatus.get_zones()`)

Returns:
    

a summary of the conflicts that were found.

Return type:
    

`DSSCodeStudioObjectConflicts`

pull_from_code_studio(_zone_)
    

Copies the files from a zone of the code studio to the DSS instance

Parameters:
    

**zone** (_str_) – name of the zone to pull (see `dataikuapi.dss.codestudio.DSSCodeStudioObjectStatus.get_zones()`)

push_to_code_studio(_zone_)
    

Copies the files from the DSS instance to a zone of the code studio

Parameters:
    

**zone** (_str_) – name of the zone to push (see `dataikuapi.dss.codestudio.DSSCodeStudioObjectStatus.get_zones()`)

Returns:
    

a dictionary of {count: <number of files copied>, size: <total size copied>}

Return type:
    

dict

change_owner(_new_owner_)
    

Allows to change the owner of the Code Studio

Note

You need to be either admin or owner of the Code Studio in order to change the owner.

Parameters:
    

**new_owner** (_str_) – the id of the new owner

Returns:
    

a handle on the updated code studio

Return type:
    

`dataikuapi.dss.codestudio.DSSCodeStudioObject`

_class _dataikuapi.dss.codestudio.DSSCodeStudioObjectListItem(_client_ , _project_key_ , _data_)
    

An item in a list of code studios.

Important

Do not instantiate this class, use [`dataikuapi.dss.project.DSSProject.list_code_studios()`](<projects.html#dataikuapi.dss.project.DSSProject.list_code_studios> "dataikuapi.dss.project.DSSProject.list_code_studios")

to_code_studio()
    

Get a handle to interact with this code studio

Returns:
    

a handle on the code studio

Return type:
    

`dataikuapi.dss.codestudio.DSSCodeStudioObject`

_property _name
    

Get the name of the code studio

Note

The name is user-provided and not necessarily unique.

Return type:
    

string

_property _id
    

Get the identifier of the code studio

Note

The id is generated by DSS upon creation and random.

Return type:
    

string

_property _owner
    

Get the login of the owner of the code studio

Return type:
    

string

_property _template_id
    

Get the identifier of the template that this code studio was created from

Return type:
    

string

_property _template_label
    

Get the label of the template that this code studio was created from

Return type:
    

string

_property _template_description
    

Get the description of the template that this code studio was created from

Return type:
    

string

_class _dataikuapi.dss.codestudio.DSSCodeStudioObjectSettings(_client_ , _project_key_ , _code_studio_id_ , _settings_)
    

Settings for a code studio

Important

Do not instantiate directly, use `dataikuapi.dss.codestudio.DSSCodeStudioObject.get_settings()` instead

get_raw()
    

Gets all settings as a raw dictionary.

Returns:
    

the settings, as a dict. The dict contains a **templateId** field indicating which code studio template was used to create this code studio.

Return type:
    

dict

_property _id
    

Get the identifier of the code studio.

Note

The id is generated by DSS upon creation and random.

Return type:
    

string

_property _name
    

Get the name of the code studio.

Note

The name is user-provided and not necessarily unique.

Return type:
    

string

_property _template_id
    

Get the identifier of the template that the code studio was created from.

Return type:
    

string

_property _lib_name
    

Get the name of the folder resource files of the code studio are stored in.

The path to the resources files is then “<dss_data_dir>/lib/code_studio/<project_key>/<lib_name>/”

Return type:
    

string

_property _owner
    

Get the login of the owner of the code studio.

Only the owner of a code studio can use it. Administrators of the project can merely stop/start code studios, not use them.

Return type:
    

string

_class _dataikuapi.dss.codestudio.DSSCodeStudioObjectStatus(_client_ , _project_key_ , _code_studio_id_ , _status_)
    

Handle to inspect the status of a code studio

Important

Do not instantiate directly, use `dataikuapi.dss.codestudio.DSSCodeStudioObject.get_status()` instead

get_raw()
    

Gets the status as a raw dict.

Note

Some fields are only defined when the code studio is running. For instance, **exposed** and **syncedZones** are empty when the code studio is not running.

Returns:
    

the dict contains a **state** field indicating whether the code studio is STOPPED, STARTING, RUNNING or STOPPING. If RUNNING, then the dict holds additional information about the zones that can be synchronized inside the pod, and the ports of the pod that are exposed.

Return type:
    

dict

_property _state
    

Get the current state of the code studio.

Possible values are STOPPED, STARTING, RUNNING, STOPPING

Return type:
    

string

_property _last_state_change
    

Get the timestamp of the last change of the state.

Returns:
    

a datetime, or None if the code studio was never started

Return type:
    

datetime.datetime

get_zones(_as_type ='names'_)
    

Get the list of the zones synchronized inside the code studio

Parameters:
    

**as_type** (_string_) – if set to “names”, then return a list of zone identifiers; if set to “objects”, then return a list of zone definitions

Returns:
    

the list of zones, each one either a string (if as_type is “names), or a dict of with a **id** field.

Return type:
    

list

_class _dataikuapi.dss.codestudio.DSSCodeStudioObjectConflicts(_zone_ , _conflicts_)
    

Summary of the conflicts on zones of a code studio.

Note

Only conflicting files are listed, that is, files added, modified or deleted in the code studio for which the corresponding file in the DSS instance has been also added, modified or deleted.

get_raw()
    

Get the raw conflicts summary.

Returns:
    

a summary of the conflicts that were found, as a dict. The top-level field is the zone checked, or ‘error’ if it wasn’t found. The dict should contain summary information about the count of changes, and **commitFrom** and **commitTo** hashes to identify the state of the files on the DSS instance at the time of the last sync to the code studio pod and now.

Return type:
    

dict

_property _is_error
    

Whether fetching the conflicts failed.

Typically this can happen if the name of the zone(s) for which the conflicts where requested is invalid.

Return type:
    

boolean

_property _authors
    

Get the authors of changes to the files.

Returns:
    

a list of logins of users who modified the conflicting files in the DSS instance.

Return type:
    

list[string]

_property _added
    

Get the list of files added in the code studio.

Returns:
    

a list of paths to files that were added in the code studio and conflict with changes on the DSS instance.

Return type:
    

list[string]

_property _modified
    

Get the list of files modified in the code studio.

Returns:
    

a list of paths to files that were modified in the code studio and conflict with changes on the DSS instance.

Return type:
    

list[string]

_property _deleted
    

Get the list of files deleted in the code studio.

Returns:
    

a list of paths to files that were deleted in the code studio and conflict with changes on the DSS instance.

Return type:
    

list[string]

_class _dataikuapi.dss.admin.DSSCodeStudioTemplateListItem(_client_ , _data_)
    

An item in a list of code studio templates.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.list_code_studio_templates()`](<client.html#dataikuapi.DSSClient.list_code_studio_templates> "dataikuapi.DSSClient.list_code_studio_templates")

to_code_studio_template()
    

Get the handle corresponding to this code studio template

Return type:
    

`DSSCodeStudioTemplate`

_property _label
    

Get the label of the template

Return type:
    

string

_property _id
    

Get the identifier of the template

Return type:
    

string

_property _build_for_configs
    

Get the list of container configurations this template is built for

Returns:
    

a list of configuration name

Return type:
    

list[string]

_property _last_built
    

Get the timestamp of the last build of the template

Returns:
    

a timestamp, or None if the template was never built

Return type:
    

`datetime.datetime`

_class _dataikuapi.dss.admin.DSSCodeStudioTemplate(_client_ , _template_id_)
    

A handle to interact with a code studio template on the DSS instance

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_code_studio_template()`](<client.html#dataikuapi.DSSClient.get_code_studio_template> "dataikuapi.DSSClient.get_code_studio_template").

get_settings()
    

Get the template’s settings.

Returns:
    

a `DSSCodeStudioTemplateSettings` object to interact with code studio template settings

Return type:
    

`DSSCodeStudioTemplateSettings`

build(_disable_docker_cache =False_)
    

Build or rebuild the template.

Note

This call needs an API key which has an user to impersonate set, or a personal API key.

Parameters:
    

**disable_docker_cache** (_boolean_) – if True, the image is build with the option **–no-cache** (optional, defaults to False)

Returns:
    

a handle to the task of building the image

Return type:
    

[`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

_class _dataikuapi.dss.admin.DSSCodeStudioTemplateSettings(_client_ , _template_id_ , _settings_)
    

The settings of a code studio template

Important

Do not instantiate directly, use `DSSCodeStudioTemplate.get_settings()`

get_raw()
    

Gets all settings as a raw dictionary.

Returns:
    

a reference to the raw settings, as a dict (not a copy). The dict contains a **type** field and the actual template settings in a **params** field.

Return type:
    

dict

get_built_for_all_container_confs()
    

Whether the template an image for each container config

Return type:
    

boolean

get_built_container_confs()
    

Get the list of container configs for which the template builds an image (if not all)

Returns:
    

a list of container configuration names

Return type:
    

list[string]

set_built_container_confs(_* configs_, _** kwargs_)
    

Set the list of container configs for which the template builds an image

Parameters:
    

  * **all** (_boolean_) – if True, an image is built for each config

  * **configs** (_list_ _[__string_ _]_) – list of configuration names to build images for




save()
    

Saves the settings of the code studio template

---

## [api-reference/python/connections]

# Connections

For usage information and examples, see [Connections](<../../concepts-and-examples/connections.html>)

_class _dataikuapi.dss.admin.DSSConnection(_client_ , _name_)
    

A connection on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_connection()`](<client.html#dataikuapi.DSSClient.get_connection> "dataikuapi.DSSClient.get_connection") instead.

get_location_info()
    

Get information about this connection.

Caution

Deprecated, use `get_info()`

get_info(_contextual_project_key =None_)
    

Get information about this connection.

Note

This call requires permissions to read connection details

Parameters:
    

**contextual_project_key** (_string_) – (optional) project key to use to resolve variables

Returns:
    

an object containing connection information

Return type:
    

`DSSConnectionInfo`

delete()
    

Delete the connection

get_settings()
    

Get the settings of the connection.

You must use `save()` on the returned object to make your changes effective on the connection.

Usage example
    
    
    # make details of a connection accessible to some groups
    connection = client.get_connection("my_connection_name")
    settings = connection.get_settings()
    readability = settings.details_readability
    readability.set_readability(False, "group1", "group2")
    settings.save()
    

Returns:
    

the settings of the connection

Return type:
    

`DSSConnectionSettings`

get_definition()
    

Get the connection’s raw definition.

Caution

Deprecated, use `get_settings()` instead.

The exact structure of the returned dict is not documented and depends on the connection type. Create connections using the DSS UI and call `get_definition()` to see the fields that are in it.

Note

This method returns a dict with passwords and secrets in their encrypted form. If you need credentials, consider using `get_info()` and `dataikuapi.dss.admin.DSSConnectionInfo.get_basic_credential()`.

Returns:
    

a connection definition, as a dict. See `DSSConnectionSettings.get_raw()`

Return type:
    

dict

set_definition(_definition_)
    

Set the connection’s definition.

Caution

Deprecated, use `get_settings()` then `DSSConnectionSettings.save()` instead.

Important

You should only `set_definition()` using an object that you obtained through `get_definition()`, not create a new dict.

Usage example
    
    
    # make details of a connection accessible to some groups
    connection = client.get_connection("my_connection_name")
    definition = connection.get_definition()
    definition['detailsReadability']['readableBy'] = 'ALLOWED'
    definition['detailsReadability']['allowedGroups'] = ['group1', 'group2']
    connection.set_definition(definition)
    

Parameters:
    

**definition** (_dict_) – the definition for the connection, as a dict.

list_local_models()
    

Returns:
    

List local models defined in this connection.

Return type:
    

list[[`DSSLocalModel`](<llm-mesh.html#dataikuapi.dss.local_model.DSSLocalModel> "dataikuapi.dss.local_model.DSSLocalModel")]

Raises:
    

**Exception** – If this connection is not of type HuggingFaceLocal.

get_local_model(_model_id_)
    

Get a handle on this local model.

Parameters:
    

**model_id** (_str_) – Identifier of the model.

Return type:
    

[`DSSLocalModel`](<llm-mesh.html#dataikuapi.dss.local_model.DSSLocalModel> "dataikuapi.dss.local_model.DSSLocalModel")

sync_root_acls()
    

Resync root permissions on this connection path.

This is only useful for HDFS connections when DSS has User Isolation activated with “DSS-managed HDFS ACL”

Returns:
    

a handle to the task of resynchronizing the permissions

Return type:
    

[`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

sync_datasets_acls()
    

Resync permissions on datasets in this connection path.

This is only useful for HDFS connections when DSS has User Isolation activated with “DSS-managed HDFS ACL”

Returns:
    

a handle to the task of resynchronizing the permissions

Return type:
    

[`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

test()
    

Test if the current connection is available.

Will return an error if there testing is not supported for this connection type.

Returns:
    

a test result as a dict, with **connectionOK** field that is True if the connection is available and False otherwise

Return type:
    

dict

_class _dataikuapi.dss.admin.DSSConnectionInfo(_data_)
    

A class holding read-only information about a connection.

Important

Do not instantiate directly, use `DSSConnection.get_info()` instead.

The main use case of this class is to retrieve the decrypted credentials for a connection, if allowed by the connection permissions.

Depending on the connection kind, the credential may be available using `get_basic_credential()` or `get_aws_credential()`.

get_type()
    

Get the type of the connection

Returns:
    

a connection type, for example Azure, Snowflake, GCS, …

Return type:
    

string

get_credential_mode()
    

Get the credential mode of the connection

Returns:
    

a connection mode

Return type:
    

string

get_params()
    

Get the parameters of the connection, as a dict

Returns:
    

the parameters, as a dict. Each connection type has different sets of fields.

Return type:
    

dict

get_resolved_params()
    

Get the resolved parameters of the connection, as a dict. May be null depending on the connection type.

Returns:
    

the resolved parameters, as a dict. Each connection type has different sets of fields.

Return type:
    

dict

get_basic_credential()
    

Get the basic credential (user/password pair) for this connection, if available

Returns:
    

the credential, as a dict containing “user” and “password”

Return type:
    

dict

get_aws_credential()
    

Get the AWS credential for this connection, if available.

The AWS credential can either be a keypair or a STS token triplet.

Returns:
    

the credential, as a dict containing “accessKey”, “secretKey”, and “sessionToken” (only in the case of STS token)

Return type:
    

dict

get_oauth2_credential()
    

Get the OAUTH2 credential for this connection, if available.

Returns:
    

the credential, as a dict containing “accessToken”

Return type:
    

dict

_class _dataikuapi.dss.admin.DSSConnectionListItem(_client_ , _data_)
    

An item in a list of connections.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.list_connections()`](<client.html#dataikuapi.DSSClient.list_connections> "dataikuapi.DSSClient.list_connections") instead.

to_connection()
    

Gets a handle corresponding to this item

Return type:
    

`DSSConnection`

_property _name
    

Get the identifier of the connection.

Return type:
    

string

_property _type
    

Get the type of the connection.

Returns:
    

a DSS connection type, like PostgreSQL, EC2, Azure, …

Return type:
    

string

_class _dataikuapi.dss.admin.DSSConnectionSettings(_connection_ , _settings_)
    

Settings of a DSS connection.

Important

Do not instantiate directly, use `DSSConnection.get_settings()` instead.

Use `save()` to save your changes

get_raw()
    

Get the raw settings of the connection.

Returns:
    

a connection definition, as a dict. Notable fields are:

  * **type** : type of the connection (for example PostgreSQL, Azure, …)

  * **params** : dict of the parameters specific to the connection type




Return type:
    

dict

_property _type
    

Get the type of the connection.

Returns:
    

a DSS connection type, like PostgreSQL, EC2, Azure, …

Return type:
    

string

_property _allow_managed_datasets
    

Whether managed datasets can use the connection.

Return type:
    

boolean

_property _allow_managed_folders
    

Whether managed datasets can use the connection.

Return type:
    

boolean

_property _allow_knowledge_banks
    

Whether Knowledge Banks can use the connection.

Return type:
    

boolean

_property _allow_write
    

Whether data can be written to this connection.

If not, the connection is read-only from DSS point of view.

Return type:
    

boolean

_property _details_readability
    

Get the access control to connection details.

Returns:
    

an handle on the access control definition.

Return type:
    

`DSSConnectionDetailsReadability`

_property _usable_by
    

Get the mode of access control.

This controls usage of the connection, that is, reading and/or writing data from/to the connection.

Returns:
    

one ALL (anybody) or ALLOWED (ie. only users from groups in `usable_by_allowed_groups()`)

Return type:
    

string

_property _usable_by_allowed_groups
    

Get the groups allowed to use the connection

Only applies if `usable_by()` is ALLOWED.

Returns:
    

a list of group names

Return type:
    

list[string]

set_usability(_all_ , _* groups_)
    

Set who can use the connection.

Parameters:
    

  * **all** (_boolean_) – if True, anybody can use the connection

  * **groups** (_list_ _[__string_ _]_) – a list of groups that can use the connection




save()
    

Save the changes to the connection’s settings

_class _dataikuapi.dss.admin.DSSConnectionDetailsReadability(_data_)
    

Handle on settings for access to connection details.

Connection details mostly cover credentials, and giving access to the credentials is necessary to some workloads. Typically, having Spark processes access data directly implies giving credentials to these Spark processes, which in turn implies that the user can access the connection’s details.

_property _readable_by
    

Get the mode of access control.

Returns:
    

one of NONE (nobody), ALL (anybody) or ALLOWED (ie. only users from groups in `allowed_groups()`)

Return type:
    

string

_property _allowed_groups
    

Get the groups allowed to access connection details.

Only applies if `readable_by()` is ALLOWED.

Returns:
    

a list of group names

Return type:
    

list[string]

set_readability(_all_ , _* groups_)
    

Set who can get details from the connection.

To make the details readable by nobody, pass all=False and no group.

Parameters:
    

  * **all** (_boolean_) – if True, anybody can use the connection

  * **groups** (_list_ _[__string_ _]_) – a list of groups that can use the connection

---

## [api-reference/python/dashboards]

# Dashboards

_class _dataikuapi.dss.dashboard.DSSDashboard(_client_ , _project_key_ , _dashboard_id_)
    

A handle to interact with a dashboard on the DSS instance.

Important

Do not instantiate directly, use `dataikuapi.dss.DSSProject.get_dashboard()` instead

delete()
    

Delete the dashboard

get_settings()
    

Get the dashboard’s definition

Returns:
    

a handle to inspect the dashboard definition

Return type:
    

`dataikuapi.dss.dashboard.DSSDashboardSettings`

_class _dataikuapi.dss.dashboard.DSSDashboardSettings(_client_ , _settings_)
    

Settings for a dashboard

Important

Do not instantiate directly, use `dataikuapi.dss.dashboard.DSSDashboard.get_settings()` instead

get_raw()
    

Gets all settings as a raw dictionary.

Returns:
    

the settings, as a dict. Fields are:

  * **projectKey** and **id** : identify the dashboard

  * **name** : name (label) of the dashboard

  * **owner** : login of the owner of the dashboard

  * **listed** : boolean indicating whether the dashboard is private or public (i.e. promoted)

  * **pages** : definition of the different slides

  * **versionTag** , **creationTag** , **checklists** , **tags** , **customFields** : common fields on DSS objects




Return type:
    

dict

save()
    

Save the settings to the dashboard

_property _id
    

Get the identifier of the dashboard

Note

The id is generated by DSS upon creation and random.

Return type:
    

string

_property _name
    

Get the name of the dashboard

Note

The name is user-provided and not necessarily unique.

Return type:
    

str

_property _listed
    

Get the boolean indicating whether the dashboard is private or public (i.e. promoted)

Return type:
    

bool

_property _owner
    

Get the login of the owner of the dashboard

Return type:
    

str

_class _dataikuapi.dss.dashboard.DSSDashboardListItem(_client_ , _data_)
    

An item in a list of dashboards.

Important

Do not instantiate this class, use [`dataikuapi.dss.project.DSSProject.list_dashboards()`](<projects.html#dataikuapi.dss.project.DSSProject.list_dashboards> "dataikuapi.dss.project.DSSProject.list_dashboards")

to_dashboard()
    

Get a handle to interact with this dashboard

Returns:
    

a handle on the dashboard

Return type:
    

`dataikuapi.dss.dashboard.DSSDashboard`

_property _id
    

Get the identifier of the dashboard

Note

The id is generated by DSS upon creation and random.

Return type:
    

string

_property _name
    

Get the name of the dashboard

Note

The name is user-provided and not necessarily unique.

Return type:
    

str

_property _listed
    

Get the boolean indicating whether the dashboard is private or public (i.e. promoted)

Return type:
    

bool

_property _owner
    

Get the login of the owner of the dashboard

Return type:
    

str

_property _num_pages
    

Get the number of pages (i.e. slides) in the dashboard

Return type:
    

int

_property _num_tiles
    

Get the number of tiles in the dashboard

Return type:
    

int

---

## [api-reference/python/data-collections]

# Data Collections

For usage information and examples, see [Data Collections](<../../concepts-and-examples/data-collections.html>)

_class _dataikuapi.dss.data_collection.DSSDataCollection(_client_ , _id_)
    

A handle to interact with a Data Collection on the DSS instance.

Do not create this class directly, instead use [`dataikuapi.DSSClient.get_data_collection()`](<client.html#dataikuapi.DSSClient.get_data_collection> "dataikuapi.DSSClient.get_data_collection") or `DSSDataCollectionListItem.to_data_collection()`

get_settings()
    

Gets the settings of this Data Collection.

Returns:
    

a handle to read, modify and save the settings

Return type:
    

`DSSDataCollectionSettings`

list_objects(_as_type ='objects'_)
    

List the objects in this Data Collection

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “objects” and “dict” (defaults to **objects**).

Returns:
    

The list of objects

Return type:
    

list of `DSSDataCollectionItem` if as_type is “objects”, list of `dict` if as_type is “dict”

add_object(_obj_)
    

Add an object to this Data Collection.

Parameters:
    

**obj** ([`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"), `DSSDataCollectionItem` or `dict`) – object to add to the Data Collection.

delete()
    

Delete this Data Collection

This call requires Administrator rights on the Data Collection.

_class _dataikuapi.dss.data_collection.DSSDataCollectionListItem(_client_ , _data_)
    

An item in a list of Data Collections.

Do not instantiate this class, use [`dataikuapi.DSSClient.list_data_collections()`](<client.html#dataikuapi.DSSClient.list_data_collections> "dataikuapi.DSSClient.list_data_collections")

get_raw()
    

Get the raw representation of this `DSSDataCollectionListItem`

Return type:
    

`dict`

_property _id
    

_property _display_name
    

_property _description
    

_property _color
    

_property _tags
    

_property _item_count
    

_property _last_modified_on
    

to_data_collection()
    

Gets the `DSSDataCollection` corresponding to this list item

Returns:
    

handle of the Data Collection

Return type:
    

`DSSDataCollection`

_class _dataikuapi.dss.data_collection.DSSDataCollectionSettings(_data_collection_ , _settings_)
    

A handle on the settings of a Data Collection

Do not create this class directly, instead use `DSSDataCollection.get_settings()`

get_raw()
    

Get the raw settings of the Data Collection. This returns a reference to the raw settings, not a copy, so changes made to the returned object will be reflected when saving.

Returns:
    

the Data Collection raw settings

Return type:
    

`dict`

_property _id
    

The Data Collection id (read-only)

Return type:
    

`str`

_property _display_name
    

Get or set the name of the Data Collection

Return type:
    

`str`

_property _color
    

Get or set the background color of the Data Collection (using #RRGGBB syntax)

Return type:
    

`str`

_property _description
    

Get or set the description of the Data Collection

Return type:
    

`str`

_property _tags
    

Get or set the tags of the Data Collection

Return type:
    

list of `str`

_property _permissions
    

Get or set the permissions controlling who is a reader, contributor or admin of the Data Collection.

If the user is not an admin of the data-collection, the permissions property will be redacted as None.

Returns:
    

a list of the Data Collection permissions

Return type:
    

list of `dict` or `None`

save()
    

Save the changes made on the settings

This call requires Administrator rights on the Data Collection.

_class _dataikuapi.dss.data_collection.DSSDataCollectionPermissionItem
    

_classmethod _admin_group(_group_)
    

Creates a `dict` representing an admin authorization for a group

_classmethod _contributor_group(_group_)
    

Creates a `dict` representing an contributor authorization for a group

_classmethod _reader_group(_group_)
    

Creates a `dict` representing an reader authorization for a group

_classmethod _admin_user(_user_)
    

Creates a `dict` representing an admin authorization for a user

_classmethod _contributor_user(_user_)
    

Creates a `dict` representing an contributor authorization for a user

_classmethod _reader_user(_user_)
    

Creates a `dict` representing an reader authorization for a user

_class _dataikuapi.dss.data_collection.DSSDataCollectionItem(_data_collection_ , _data_)
    

A handle on an object inside a Data Collection

Do not create this class directly, instead use `DSSDataCollection.list_objects()`

get_raw()
    

Get the raw description of the Data Collection item. This returns a reference to the raw data, not a copy.

Returns:
    

the Data Collection item raw description

Return type:
    

`dict`

get_as_dataset()
    

Gets a handle on the corresponding dataset.

Attention

The usability of this handle might be limited by the current user’s authorizations, as seeing a dataset in a data-collection doesn’t necessarily imply a lot of rights.

Returns:
    

a handle on a dataset

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

remove()
    

Remove this object from the Data Collection

This call requires Contributor rights on the Data Collection.

---

## [api-reference/python/data-quality]

# Data Quality

For usage information and examples, see [Data Quality](<../../concepts-and-examples/data-quality.html>)

_class _dataikuapi.dss.data_quality.DSSDataQualityRuleSet(_project_key_ , _dataset_name_ , _client_)
    

Base settings class for dataset data quality rules.

Caution

Do not instantiate this class directly, use [`dataikuapi.dss.dataset.DSSDataset.get_data_quality_rules()`](<datasets.html#dataikuapi.dss.dataset.DSSDataset.get_data_quality_rules> "dataikuapi.dss.dataset.DSSDataset.get_data_quality_rules")

list_rules(_as_type ='objects'_)
    

Get the list of rules defined on the dataset.

Parameters:
    

**as_type** (_str_) – How to return the rules. Possible values are “dict” and “objects” (defaults to **objects**)

Returns:
    

The rules defined on the dataset.

Return type:
    

a list of `DSSDataQualityRule` if as_type is “objects”, a list of dict if as_type is “dict”

create_rule(_config =None_)
    

Create a data quality rule on the current dataset.

Parameters:
    

**config** (_object_) – The config of the rule

Returns:
    

The created data quality rule

Return type:
    

`DSSDataQualityRule`

get_partitions_status(_partitions ='NP'_)
    

Get the last computed status of the specified partition(s).

Parameters:
    

**partitions** – The list of partitions name or the name of the partition to get the last status (or “ALL” to retrieve the whole dataset partition). If the dataset is not partitioned use “NP” or None.

Returns:
    

the status of the specified partitions if they exists

Return type:
    

object

compute_rules(_partition ='NP'_)
    

Compute all data quality enabled rules of the current dataset.

Parameters:
    

**partition** (_str_) – If the dataset is partitioned, the name of the partition to compute (or “ALL” to compute on the whole dataset). If the dataset is not partitioned use “NP” or None.

Returns:
    

Job of the currently computed data quality rules.

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

get_status()
    

Get the status of the dataset. For partitioned dataset this is the worst result of the last computed partitions.

Returns:
    

The status of the dataset.

Return type:
    

str

get_status_by_partition(_include_all_partitions =False_)
    

Return the status of a dataset detailed per partition used to compute it if any. If the dataset is not partitioned it will contain only one result.

Parameters:
    

**include_all_partitions** (_boolean_) – Include all the partition having a data quality status or only the one relevant to the current status of the dataset. Default is False.

Returns:
    

The current status of each last built partitions of the dataset

Return type:
    

dict

get_last_rules_results(_partition ='NP'_)
    

Return the last result of all the rules defined on the dataset on a specified partition. If the dataset is not partitioned it will get all the last rules results

Parameters:
    

**partition** (_str_) – If the dataset is partitioned, the name of the partition to get the detailed rules results (or “ALL” to compute on the whole dataset). If the dataset is not partitioned use “NP” or None.

Returns:
    

The last result of each rule on the specified partition

Return type:
    

a list of `DSSDataQualityRuleResult`

get_rules_history(_min_timestamp =None_, _max_timestamp =None_, _results_per_page =10000_, _page =0_, _rule_ids =None_)
    

Get the history of computed rules.

Parameters:
    

  * **min_timestamp** (_int_) – Timestamp representing the beginning of the timeframe. (included)

  * **max_timestamp** (_int_) – Timestamp representing the end of the timeframe. (included)

  * **results_per_page** (_int_) – The maximum number of records to be returned, default will be the last 10 000 records.

  * **page** (_int_) – The page to be returned, default will be first page (page=0).

  * **rule_ids** (_list_) – A list of rule ids to get the history from. Default is all the rules on the dataset.



Returns:
    

The detailed execution of data quality rules matching the filters set

Return type:
    

a list of `DSSDataQualityRuleResult`

delete_rules_history(_partition ='NP'_)
    

Delete the history of computed rules for a single partition.

Parameters:
    

**partition** (_string_) – If the dataset is partitioned, the name of the partition to compute (or “ALL” for rules computed on the whole dataset). If the dataset is not partitioned, use “NP” or None.

_class _dataikuapi.dss.data_quality.DSSDataQualityRule(_rule_ , _dataset_name_ , _project_key_ , _client_)
    

A rule defined on a dataset.

Caution

Do not instantiate this class, use `DSSDataQualityRuleSet.list_rules()`

get_raw()
    

Get the raw representation of this `DSSDataQualityRule`

Return type:
    

`dict`

_property _id
    

_property _name
    

compute(_partition ='NP'_)
    

Compute the rule on a given partition or the full dataset.

Parameters:
    

**partition** (_str_) – If the dataset is partitioned, the name of the partition to compute (or “ALL” to compute on the whole dataset). If the dataset is not partitioned use “NP” or None.

Returns:
    

A job of the computation of the rule.

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

save()
    

Save the settings of a rule.

Returns:
    

‘Success’

Return type:
    

str

delete()
    

Delete the rule from the dataset configuration.

get_last_result(_partition ='NP'_)
    

Return the last result of the rule on a specified dataset/partition.

Parameters:
    

**partition** (_str_) – If the dataset is partitioned, the name of the partition to get the detailed rules results (or “ALL” to refer to the whole dataset). If the dataset is not partitioned use “NP” or None.

Returns:
    

The last result of the rule on the specified partition

Return type:
    

`DSSDataQualityRuleResult`

get_rule_history(_min_timestamp =None_, _max_timestamp =None_, _results_per_page =10000_, _page =0_)
    

Get the history of the current rule.

Parameters:
    

  * **min_timestamp** (_int_) – Timestamp representing the beginning of the timeframe. (included)

  * **max_timestamp** (_int_) – Timestamp representing the end of the timeframe. (included)

  * **results_per_page** (_int_) – The maximum number of records to be returned, default will be the last 10 000 records.

  * **page** (_int_) – The page to be returned, default will be first page.



Returns:
    

The detailed execution of data quality rule matching the timeframe set

Return type:
    

a list of `DSSDataQualityRuleResult`

_class _dataikuapi.dss.data_quality.DSSDataQualityRuleResult(_data_)
    

The result of a rule defined on a dataset

Caution

Do not instantiate this class, use: `DSSDataQualityRuleSet.get_last_rules_results()` or `DSSDataQualityRuleSet.get_rules_history()` or `DSSDataQualityRule.get_last_result()` or `DSSDataQualityRule.get_rule_history()`

get_raw()
    

Get the raw representation of this `DSSDataQualityRuleResult`

Return type:
    

`dict`

_property _id
    

_property _name
    

_property _outcome
    

_property _message
    

_property _compute_date
    

_property _run_origin
    

_property _partition

---

## [api-reference/python/databricks-connect]

# Databricks Connect

For usage information and examples, see [Databricks Connect](<../../concepts-and-examples/databricks-connect.html>)

_class _dataiku.dbconnect.DkuDBConnect(_serverless =False_)
    

Handle to create Databricks Connect sessions from DSS datasets or connections

create_session(_connection_name_ , _project_key =None_)
    

Creates a new session configured to read on the supplied DSS connection.

get_dataframe(_dataset_ , _session =None_)
    

Return a DataFrame configured to read the table that is underlying the specified dataset.

get_session(_connection_name_ , _project_key =None_)
    

Return session configured to read on the supplied DSS connection.

write_dataframe(_dataset_ , _df_ , _infer_schema =False_, _force_direct_write =False_, _dropAndCreate =False_)
    

Writes this dataset (or its target partition, if applicable) from a single dataframe.

This variant only edit the schema if infer_schema is True, otherwise you must take care to only write dataframes that have a compatible schema. Also see “write_with_schema”.

Parameters:
    

  * **df** – input dataframe.

  * **dataset** – Output dataset to write.

  * **infer_schema** – infer the schema from the dataframe.

  * **force_direct_write** – Force writing the dataframe using the direct API into the dataset even if they don’t come from the same DSS connection.

  * **dropAndCreate** – if infer_schema and this parameter are both set to True, clear and recreate the dataset structure.




write_with_schema(_dataset_ , _df_ , _force_direct_write =False_, _dropAndCreate =False_)
    

Writes this dataset (or its target partition, if applicable) from a single dataframe.

This variant replaces the schema of the output dataset with the schema of the dataframe.

Parameters:
    

  * **df** – input dataframe.

  * **dataset** – Output dataset to write.

  * **force_direct_write** – Force writing the dataframe using the direct API into the dataset even if they don’t come from the same DSS connection.

  * **dropAndCreate** – drop and recreate the dataset.

---

## [api-reference/python/dataiku-applications]

# Dataiku applications

For usage information and examples, see [Dataiku Applications](<../../concepts-and-examples/dataiku-applications.html>)

_class _dataikuapi.dss.app.DSSApp(_client_ , _app_id_)
    

A handle to interact with an application on the DSS instance.

Important

Do not instantiate this class directly, instead use [`dataikuapi.DSSClient.get_app()`](<client.html#dataikuapi.DSSClient.get_app> "dataikuapi.DSSClient.get_app").

create_instance(_instance_key_ , _instance_name_ , _wait =True_, _is_temporary_instance =False_)
    

Create a new instance of this application.

Each instance requires a unique instance_key, distinct from all other project keys throughout the DSS instance.

Parameters:
    

  * **instance_key** (_string_) – project key for the newly created app instance

  * **instance_name** (_string_) – name for the newly created app instance

  * **wait** (_boolean_) – if False, the method returns immediately with a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") on which to wait for the app instance to be created

  * **is_temporary_instance** (_boolean_) – whether this instance will be temporary (in which case git and its indexing in the catalog is disabled)



Returns:
    

a handle to interact with the app instance

Return type:
    

`DSSAppInstance`

make_random_project_key()
    

Create a new project key based on this app name.

This method suffixes the app’s name with a random string to generate a unique app instance key.

Returns:
    

a project key

Return type:
    

string

create_temporary_instance()
    

Create a new temporary instance of this application.

The return value should be used as a Python context manager. Upon exit, the temporary app instance is deleted.

Returns:
    

an app instance

Return type:
    

`TemporaryDSSAppInstance`

list_instance_keys()
    

List the keys of the existing instances of this app.

Returns:
    

a list of instance keys

Return type:
    

list[string]

list_instances()
    

List the existing instances of this app.

:return a list of instances, each as a dict containing at least a “projectKey” field :rtype: list

get_instance(_instance_key_)
    

Get an instance of this app by instance key.

Returns:
    

an app instance

Return type:
    

`DSSAppInstance`

get_manifest()
    

Get the manifest of this app.

Returns:
    

an app manifest

Return type:
    

`DSSAppManifest`

_class _dataikuapi.dss.app.DSSAppListItem(_client_ , _data_)
    

An app item in a list of apps.

Important

Do not instantiate this class directly, instead use [`dataikuapi.DSSClient.list_apps()`](<client.html#dataikuapi.DSSClient.list_apps> "dataikuapi.DSSClient.list_apps").

to_app()
    

Get a handle corresponding to this app.

Returns:
    

a handle to interact with the app.

Return type:
    

`dataikuapi.dss.app.DSSApp`

_class _dataikuapi.dss.app.DSSAppInstance(_client_ , _project_key_)
    

Handle on an instance of an app.

Important

Do not instantiate this class directly, instead use `dataikuapi.dss.app.DSSApp.get_instance()`.

get_as_project()
    

Get a handle on the project corresponding to this application instance.

Returns:
    

a handle on a DSS project

Return type:
    

[`dataikuapi.dss.project.DSSProject`](<projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")

get_manifest()
    

Get the manifest of this app instance.

Returns:
    

an app manifest

Return type:
    

`DSSAppManifest`

_class _dataikuapi.dss.app.DSSAppManifest(_client_ , _raw_data_ , _project_key =None_)
    

Handle on the manifest of an app or an app instance.

Important

Do not instantiate this class directly, instead use `dataikuapi.dss.app.DSSApp.get_manifest()` or `dataikuapi.dss.app.DSSAppInstance.get_manifest()`.

get_raw()
    

Get the raw definition of the manifest.

Usage example:
    
    
    # list all app templates that anybody can instantiate
    for app in client.list_apps(as_type="objects"):
        manifest = app.get_manifest()
        if manifest.get_raw()["instantiationPermission"] == 'EVERYBODY':
            print(app.app_id)            
    

Returns:
    

the definition of the manifest, as a dict. The definitions of the tiles of the app are inside the **homepageSections** field, which is a list of the sections displayed in the app. When the app is an app-as-recipe, the field **useAsRecipeSettings** is defined and contains the recipe-specific settings.

Return type:
    

dict

get_all_actions()
    

Get the flat list of all actions.

Returns:
    

a list of action defintions, each one a dict. Each action has these fields:

  * **type** : the type of the action

  * **prompt** : label of the action in the form

  * **help** and **helpTitle** : metadata for showing a help button on the action

  * … and depending on the type of action, other fields that hold the action’s setup.




Return type:
    

list

get_runnable_scenarios()
    

Get the scenario identifiers that are declared as actions for this app.

Returns:
    

a list of scenario identifiers

Return type:
    

list[string]

save()
    

Save the changes of this manifest object in the template project.

_class _dataikuapi.dss.app.TemporaryDSSAppInstance(_client_ , _project_key_)
    

Variant of `DSSAppInstance` that can be used as a Python context.

Important

Do not instantiate this class directly, instead use `dataikuapi.dss.app.DSSApp.create_temporary_instance()`

close()
    

Delete this app instance.

---

## [api-reference/python/dataiku-index]

# Index of the `dataiku` package

This page contains the index of classes and functions in the `dataiku` package and serve as entrypoint to its reference API documentation

## Datasets

[`dataiku.Dataset`](<datasets.html#dataiku.Dataset> "dataiku.Dataset")(name[, project_key, ignore_flow]) | Provides a handle to obtain readers and writers on a dataiku Dataset.  
---|---  
[`dataiku.core.dataset_write.DatasetWriter`](<datasets.html#dataiku.core.dataset_write.DatasetWriter> "dataiku.core.dataset_write.DatasetWriter")(dataset) | Handle to write to a dataset.  
  
## Managed folders

[`dataiku.Folder`](<managed-folders.html#dataiku.Folder> "dataiku.Folder")(lookup[, project_key, ...]) | Handle to interact with a folder.  
---|---  
`dataiku.core.managed_folder.ManagedFolderWriter`(...) | Handle to write to a managed folder  
  
## Streaming Endpoints

[`dataiku.StreamingEndpoint`](<streaming-endpoints.html#dataiku.StreamingEndpoint> "dataiku.StreamingEndpoint")(id[, project_key]) | This is a handle to obtain readers and writers on a dataiku streaming endpoint.  
---|---  
  
## Saved models

[`dataiku.Model`](<ml.html#dataiku.Model> "dataiku.Model")(lookup[, project_key, ignore_flow]) | Handle to interact with a saved model.  
---|---  
  
## Metrics and checks

[`dataiku.core.metrics.ComputedMetrics`](<metrics.html#dataiku.core.metrics.ComputedMetrics> "dataiku.core.metrics.ComputedMetrics")(raw) | Handle to the metrics of a DSS object and their last computed value  
---|---  
[`dataiku.core.metrics.MetricDataPoint`](<metrics.html#dataiku.core.metrics.MetricDataPoint> "dataiku.core.metrics.MetricDataPoint")(raw) | A value of a metric, on a partition  
[`dataiku.core.metrics.ComputedChecks`](<metrics.html#dataiku.core.metrics.ComputedChecks> "dataiku.core.metrics.ComputedChecks")(raw) | Handle to the checks of a DSS object and their last computed value  
[`dataiku.core.metrics.CheckDataPoint`](<metrics.html#dataiku.core.metrics.CheckDataPoint> "dataiku.core.metrics.CheckDataPoint")(raw) | A value of a check, on a partition  
  
## Model Evaluation Stores

[`dataiku.core.model_evaluation_store.ModelEvaluationStore`](<model-evaluation-stores.html#dataiku.ModelEvaluationStore> "dataiku.core.model_evaluation_store.ModelEvaluationStore")(lookup) | This is a handle to interact with a model evaluation store.  
---|---  
[`dataiku.core.model_evaluation_store.ModelEvaluation`](<model-evaluation-stores.html#dataiku.core.model_evaluation_store.ModelEvaluation> "dataiku.core.model_evaluation_store.ModelEvaluation")(...) | This is a handle to interact with a model evaluation from a model evaluation store.  
  
## Projects

[`dataiku.Project`](<projects.html#dataiku.Project> "dataiku.Project")([project_key]) | This is a handle to interact with the current project  
---|---

---

## [api-reference/python/dataikuapi-index]

# Index of the `dataikuapi` package  
  
This page contains the index of classes in the `dataikuapi` package and serve as entrypoint to its reference API documentation

## Core classes

[`dataikuapi.DSSClient`](<client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.project.DSSProject`](<projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
  
## Project folders

[`dataikuapi.dss.projectfolder.DSSProjectFolder`](<project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder> "dataikuapi.dss.projectfolder.DSSProjectFolder")(...) | A handle for a project folder on the DSS instance.  
---|---  
[`dataikuapi.dss.projectfolder.DSSProjectFolderSettings`](<project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolderSettings> "dataikuapi.dss.projectfolder.DSSProjectFolderSettings")(...) | A handle for a project folder settings.  
  
## Datasets

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")(client, ...) | A dataset on the DSS instance.  
---|---  
  
## Statistics worksheets

[`dataikuapi.dss.statistics.DSSStatisticsWorksheet`](<statistics.html#dataikuapi.dss.statistics.DSSStatisticsWorksheet> "dataikuapi.dss.statistics.DSSStatisticsWorksheet")(...) | A handle to interact with a worksheet.  
---|---  
  
## Managed folders

[`dataikuapi.dss.managedfolder.DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder")(...) | A handle to interact with a managed folder on the DSS instance.  
---|---  
  
## Streaming endpoint

[`dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")(...) | A streaming endpoint on the DSS instance.  
---|---  
  
## Recipes

[`dataikuapi.dss.recipe.DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe")(client, ...) | A handle to an existing recipe on the DSS instance.  
---|---  
[`dataikuapi.dss.recipe.GroupingRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.GroupingRecipeCreator> "dataikuapi.dss.recipe.GroupingRecipeCreator")(...) | Create a Group recipe.  
[`dataikuapi.dss.recipe.JoinRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.JoinRecipeCreator> "dataikuapi.dss.recipe.JoinRecipeCreator")(...) | Create a Join recipe.  
[`dataikuapi.dss.recipe.StackRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.StackRecipeCreator> "dataikuapi.dss.recipe.StackRecipeCreator")(...) | Create a Stack recipe  
[`dataikuapi.dss.recipe.WindowRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.WindowRecipeCreator> "dataikuapi.dss.recipe.WindowRecipeCreator")(...) | Create a Window recipe  
[`dataikuapi.dss.recipe.SyncRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.SyncRecipeCreator> "dataikuapi.dss.recipe.SyncRecipeCreator")(...) | Create a Sync recipe  
[`dataikuapi.dss.recipe.SamplingRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.SamplingRecipeCreator> "dataikuapi.dss.recipe.SamplingRecipeCreator")(...) | Create a Sample/Filter recipe  
[`dataikuapi.dss.recipe.SQLQueryRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.SQLQueryRecipeCreator> "dataikuapi.dss.recipe.SQLQueryRecipeCreator")(...) | Create a SQL query recipe.  
[`dataikuapi.dss.recipe.CodeRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.CodeRecipeCreator> "dataikuapi.dss.recipe.CodeRecipeCreator")(...) | Create a recipe running a script.  
[`dataikuapi.dss.recipe.SplitRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.SplitRecipeCreator> "dataikuapi.dss.recipe.SplitRecipeCreator")(...) | Create a Split recipe  
[`dataikuapi.dss.recipe.EvaluationRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.EvaluationRecipeCreator> "dataikuapi.dss.recipe.EvaluationRecipeCreator")(...) | Create a new Evaluate recipe.  
[`dataikuapi.dss.recipe.StandaloneEvaluationRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.StandaloneEvaluationRecipeCreator> "dataikuapi.dss.recipe.StandaloneEvaluationRecipeCreator")(...) | Create a new Standalone Evaluate recipe.  
[`dataikuapi.dss.recipe.LLMEvaluationRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.LLMEvaluationRecipeCreator> "dataikuapi.dss.recipe.LLMEvaluationRecipeCreator")(...) | Create a new LLM Evaluate recipe.  
[`dataikuapi.dss.recipe.AgentEvaluationRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.AgentEvaluationRecipeCreator> "dataikuapi.dss.recipe.AgentEvaluationRecipeCreator")(...) | Create a new Agent Evaluation recipe.  
  
## Machine Learning

[`dataikuapi.dss.ml.DSSMLTask`](<ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask")(client, ...) | A handle to interact with a ML Task for prediction or clustering in a DSS visual analysis.  
---|---  
[`dataikuapi.dss.ml.DSSMLTaskSettings`](<ml.html#dataikuapi.dss.ml.DSSMLTaskSettings> "dataikuapi.dss.ml.DSSMLTaskSettings")(client, ...) | Object to read and modify the settings of an existing ML task.  
  
## Experiment Tracking

[`dataikuapi.dss.mlflow.DSSMLflowExtension`](<experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension> "dataikuapi.dss.mlflow.DSSMLflowExtension")(...) | A handle to interact with specific endpoints of the DSS MLflow integration.  
---|---  
  
## Code Studios

[`dataikuapi.dss.codestudio.DSSCodeStudioObject`](<code-studios.html#dataikuapi.dss.codestudio.DSSCodeStudioObject> "dataikuapi.dss.codestudio.DSSCodeStudioObject")(...) | A handle to manage a code studio in a project  
---|---  
  
## Jobs

[`dataikuapi.dss.job.DSSJob`](<jobs.html#dataikuapi.dss.job.DSSJob> "dataikuapi.dss.job.DSSJob")(client, ...) | A job on the DSS instance.  
---|---  
  
## Scenarios

[`dataikuapi.dss.scenario.DSSScenario`](<scenarios.html#dataikuapi.dss.scenario.DSSScenario> "dataikuapi.dss.scenario.DSSScenario")(client, ...) | A handle to interact with a scenario on the DSS instance.  
---|---  
[`dataikuapi.dss.scenario.DSSScenarioRun`](<scenarios.html#dataikuapi.dss.scenario.DSSScenarioRun> "dataikuapi.dss.scenario.DSSScenarioRun")(...) | A handle containing basic info about a past run of a scenario.  
[`dataikuapi.dss.scenario.DSSTriggerFire`](<scenarios.html#dataikuapi.dss.scenario.DSSTriggerFire> "dataikuapi.dss.scenario.DSSTriggerFire")(...) | A handle representing the firing of a trigger on a scenario.  
  
## API node services

[`dataikuapi.dss.apiservice.DSSAPIService`](<api-designer.html#dataikuapi.dss.apiservice.DSSAPIService> "dataikuapi.dss.apiservice.DSSAPIService")(...) | An API Service from the API Designer on the DSS instance.  
---|---  
[`dataikuapi.dss.ml.DSSMLTask`](<ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask")(client, ...) | A handle to interact with a ML Task for prediction or clustering in a DSS visual analysis.  
  
## User-defined meanings

[`dataikuapi.dss.meaning.DSSMeaning`](<meanings.html#dataikuapi.dss.meaning.DSSMeaning> "dataikuapi.dss.meaning.DSSMeaning")(client, id) | A user-defined meaning on the DSS instance  
---|---  
  
## Administration

[`dataikuapi.dss.admin.DSSUser`](<users-groups.html#dataikuapi.dss.admin.DSSUser> "dataikuapi.dss.admin.DSSUser")(client, login) | A handle for a user on the DSS instance.  
---|---  
[`dataikuapi.dss.admin.DSSGroup`](<users-groups.html#dataikuapi.dss.admin.DSSGroup> "dataikuapi.dss.admin.DSSGroup")(client, name) | A group on the DSS instance.  
[`dataikuapi.dss.admin.DSSConnection`](<connections.html#dataikuapi.dss.admin.DSSConnection> "dataikuapi.dss.admin.DSSConnection")(client, name) | A connection on the DSS instance.  
[`dataikuapi.dss.admin.DSSAuthorizationMatrix`](<users-groups.html#dataikuapi.dss.admin.DSSAuthorizationMatrix> "dataikuapi.dss.admin.DSSAuthorizationMatrix")(...) | The authorization matrix of all groups and enabled users of the DSS instance.  
[`dataikuapi.dss.admin.DSSGeneralSettings`](<other-administration.html#dataikuapi.dss.admin.DSSGeneralSettings> "dataikuapi.dss.admin.DSSGeneralSettings")(client) | The general settings of the DSS instance.  
[`dataikuapi.dss.admin.DSSUserImpersonationRule`](<other-administration.html#dataikuapi.dss.admin.DSSUserImpersonationRule> "dataikuapi.dss.admin.DSSUserImpersonationRule")([raw]) | An user-level rule items for the impersonation settings  
[`dataikuapi.dss.admin.DSSGroupImpersonationRule`](<other-administration.html#dataikuapi.dss.admin.DSSGroupImpersonationRule> "dataikuapi.dss.admin.DSSGroupImpersonationRule")([raw]) | A group-level rule items for the impersonation settings  
[`dataikuapi.dss.admin.DSSInstanceVariables`](<other-administration.html#dataikuapi.dss.admin.DSSInstanceVariables> "dataikuapi.dss.admin.DSSInstanceVariables")(...) | Dict containing the instance variables.  
[`dataikuapi.dss.admin.DSSGlobalUsageSummary`](<other-administration.html#dataikuapi.dss.admin.DSSGlobalUsageSummary> "dataikuapi.dss.admin.DSSGlobalUsageSummary")(data) | The summary of the usage of the DSS instance.  
[`dataikuapi.dss.admin.DSSPersonalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSPersonalApiKey> "dataikuapi.dss.admin.DSSPersonalApiKey")(...) | A personal API key on the DSS instance.  
[`dataikuapi.dss.admin.DSSPersonalApiKeyListItem`](<other-administration.html#dataikuapi.dss.admin.DSSPersonalApiKeyListItem> "dataikuapi.dss.admin.DSSPersonalApiKeyListItem")(...) | An item in a list of personal API key.  
[`dataikuapi.dss.admin.DSSGlobalApiKey`](<other-administration.html#dataikuapi.dss.admin.DSSGlobalApiKey> "dataikuapi.dss.admin.DSSGlobalApiKey")(client, ...) | A global API key on the DSS instance  
[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")(client, job_id) | A future represents a long-running task on a DSS instance.  
[`dataikuapi.dss.admin.DSSCluster`](<clusters.html#dataikuapi.dss.admin.DSSCluster> "dataikuapi.dss.admin.DSSCluster")(client, ...) | A handle to interact with a cluster on the DSS instance.  
[`dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint`](<footprint.html#dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint> "dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint")(client) | Handle to analyze the footprint of data directories  
  
## Jupyter notebooks

[`dataikuapi.dss.jupyternotebook.DSSJupyterNotebook`](<other-administration.html#dataikuapi.dss.jupyternotebook.DSSJupyterNotebook> "dataikuapi.dss.jupyternotebook.DSSJupyterNotebook")(...) | A handle on a Python/R/scala notebook.  
---|---  
  
## SQL notebooks

[`dataikuapi.dss.sqlnotebook.DSSSQLNotebook`](<other-administration.html#dataikuapi.dss.sqlnotebook.DSSSQLNotebook> "dataikuapi.dss.sqlnotebook.DSSSQLNotebook")(...) | A handle on a SQL notebook  
---|---  
[`dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem`](<other-administration.html#dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem> "dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem")(...) | An item in a list of SQL notebooks  
[`dataikuapi.dss.sqlnotebook.DSSNotebookContent`](<other-administration.html#dataikuapi.dss.sqlnotebook.DSSNotebookContent> "dataikuapi.dss.sqlnotebook.DSSNotebookContent")(...) | The content of a SQL notebook  
[`dataikuapi.dss.sqlnotebook.DSSNotebookHistory`](<other-administration.html#dataikuapi.dss.sqlnotebook.DSSNotebookHistory> "dataikuapi.dss.sqlnotebook.DSSNotebookHistory")(...) | The history of a SQL notebook  
[`dataikuapi.dss.sqlnotebook.DSSNotebookQueryRunListItem`](<other-administration.html#dataikuapi.dss.sqlnotebook.DSSNotebookQueryRunListItem> "dataikuapi.dss.sqlnotebook.DSSNotebookQueryRunListItem")(...) | An item in a list of query runs of a SQL notebook  
  
## SQL queries

[`dataikuapi.dss.sqlquery.DSSSQLQuery`](<sqlquery.html#dataikuapi.dss.sqlquery.DSSSQLQuery> "dataikuapi.dss.sqlquery.DSSSQLQuery")(client, ...) | A connection to a database or database-like on which queries can be run through DSS.  
---|---  
  
## Metrics and checks

[`dataikuapi.dss.metrics.ComputedMetrics`](<metrics.html#dataikuapi.dss.metrics.ComputedMetrics> "dataikuapi.dss.metrics.ComputedMetrics")(raw) | Handle to the metrics of a DSS object and their last computed value  
---|---  
  
## Model Evaluation Store

[`dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore")(...) | A handle to interact with a model evaluation store on the DSS instance.  
---|---  
[`dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStoreSettings`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStoreSettings> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStoreSettings")(...) | A handle on the settings of a model evaluation store  
[`dataikuapi.dss.modelevaluationstore.DSSModelEvaluation`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluation> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluation")(...) | A handle on a model evaluation  
[`dataikuapi.dss.modelevaluationstore.DSSModelEvaluationFullInfo`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationFullInfo> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationFullInfo")(...) | A handle on the full information on a model evaluation.

---

## [api-reference/python/datasets]

# Datasets  
  
Please see [Datasets](<../../concepts-and-examples/datasets/index.html>) for an introduction to interacting with datasets in Dataiku Python API

## The dataiku.Dataset class

_class _dataiku.Dataset(_name_ , _project_key =None_, _ignore_flow =False_)
    

Provides a handle to obtain readers and writers on a dataiku Dataset. From this Dataset class, you can:

>   * Read a dataset as a Pandas dataframe
> 
>   * Read a dataset as a chunked Pandas dataframe
> 
>   * Read a dataset row-by-row
> 
>   * Write a pandas dataframe to a dataset
> 
>   * Write a series of chunked Pandas dataframes to a dataset
> 
>   * Write to a dataset row-by-row
> 
>   * Edit the schema of a dataset
> 
> 


Parameters:
    

  * **name** (_str_) – The name of the dataset.

  * **project_key** (_str_) – The key of the project in which the dataset is located (current project key if none is specified)

  * **ignore_flow** (_boolean_) – this parameter is only relevant for recipes, not for notebooks or code in metrics or scenario steps. when in a recipe, if it’s left to False, then DSS also checks whether the dataset is part of the inputs or outputs of the recipe and raises an error if it’s not, defaults to False



Returns:
    

a handle to interact with the dataset

Return type:
    

`Dataset`

_static _list(_project_key =None_)
    

List the names of datasets of a given project.

Usage example:
    
    
    import dataiku
    
    # current project datasets
    current_project_datasets = dataiku.Dataset.list()
    
    # given project datasets
    my_project_datasets =  dataiku.Dataset.list("my_project")
    

Parameters:
    

**project_key** (_str_) – the optional key of the project to retrieve the datasets from, defaults to current project

Returns:
    

a list of a dataset names

Return type:
    

list[str]

_property _full_name
    

Get the fully-qualified identifier of the dataset on the DSS instance.

Returns:
    

a fully qualified identifier for the dataset in the form “project_key.dataset_name”

Return type:
    

str

get_location_info(_sensitive_info =False_)
    

Retrieve the location information of the dataset.

Usage example
    
    
    # save a dataframe to csv with fixed name to S3
    dataset = dataiku.Dataset("my_target_dataset")
    location_info = dataset.get_location_info(True)
    
    s3_folder = location_info["info"]["path"] # get URI of the dataset
    import re
    # extract the bucket from the URI
    s3_bucket = re.match("^s3://([^/]+)/.*$", s3_folder).group(1)
    # extract path inside bucket
    s3_path_in_bucket = re.match("^s3://[^/]+/(.*)$", s3_folder).group(1)
    
    # save to S3 using boto
    from io import StringIO
    import boto3
    csv_buffer = StringIO()
    df.to_csv(csv_buffer)
    s3_resource = boto3.resource('s3')
    s3_resource.Object(s3_bucket, s3_path_in_bucket + '/myfile.csv').put(Body=csv_buffer.getvalue())
    

Parameters:
    

**sensitive_info** (_boolean_) – whether or not to provide sensitive infos such as passwords, conditioned on the user being allowed to read details of the connection on which this dataset is defined

Returns:
    

a dict with the location info, with as notable fields:

  * **locationInfoType** : type of location. Possible values are ‘FS’, ‘HDFS’, ‘UPLOADED’, ‘SQL’

  * **info** : a dict whose structure depends on the type of connection

>     * **connectionName** : connection name, if any
> 
>     * **connectionParams** : parameters of the connection on which the dataset is defined, as a dic, if any. The actual fields depend on the connection type. For S3 dataset, this will for example contain the bucket and credentials.
> 
>     * **path** : the URI of the dataset, if any




Return type:
    

dict

get_files_info(_partitions =[]_)
    

Get information on the files of the dataset, with details per partition.

Parameters:
    

**partitions** (_list_ _[__str_ _]__,__optional_) – list of partition identifiers, defaults to all partitions

Returns:
    

global files information and per partitions

  * **globalPaths** : list of files of the dataset.

>     * **path** : file path
> 
>     * **lastModified** : timestamp of last file update, in milliseconds
> 
>     * **size** : size of the file, in bytes

  * **pathsByPartition** : files grouped per partition, as a dict of partition identifier to list of files (same structure as **globalPaths**)




Return type:
    

dict

set_write_partition(_spec_)
    

Set which partition of the dataset gets written to when you create a DatasetWriter.

Caution

Setting the write partition is not allowed in Python recipes, where write is controlled by the Flow.

Parameters:
    

**spec** (_string_) – partition identifier

add_read_partitions(_spec_)
    

Add a partition or range of partitions to read.

Caution

You cannot manually add read partitions when running inside a Python recipe. They are automatically computed according to the partition dependencies defined on the recipe’s Input/Output tab.

Parameters:
    

**spec** (_string_) – partition spec, or partition identifier

read_schema(_raise_if_empty =True_)
    

Get the schema of this dataset, as an array of column definition.

Parameters:
    

**raise_if_empty** (_bool_ _,__optional_) – raise an exception if there is no column, defaults to True

Returns:
    

list of column definitions

Return type:
    

`dataiku.core.dataset.Schema`

list_partitions(_raise_if_empty =True_)
    

List the partitions of this dataset, as an array of partition identifiers.

Usage example
    
    
    # build a list of partitions for use in a build/train step in a scenario
    dataset = dataiku.Dataset("some_input_dataset")
    partitions = dataset.list_partitions()
    variable_value = ','.join(partitions)
    
    # set as a variable, to use in steps after this one
    Scenario().set_scenario_variables(som_variable_name=variable_value)
    

Parameters:
    

**raise_if_empty** (_bool_ _,__optional_) – raise an exception if there is no partition, defaults to True

Returns:
    

list of partitions identifiers

Return type:
    

list[string]

get_fast_path_dataframe(_auto_fallback =False_, _columns =None_, _pandas_read_kwargs =None_, _print_deep_memory_usage =True_)
    

Reads the dataset as a Pandas dataframe, using fast-path access (without going through DSS), if possible.

Pandas dataframes are fully in-memory, so you need to make sure that your dataset will fit in RAM before using this.

The fast path method provides better performance than the usual `get_dataframe()` method, but is only compatible with some dataset types and formats.

Fast path requires the “permission details readable” to be granted on the connection.

Dataframes obtained using this method may differ from those using `get_dataframe()`, notably around schemas and data. `get_dataframe()` provides a unified API with the same schema and data for all connections. On the other hand, this method uses dataset-specific access patterns that may yield different results.

At the moment, this fast path is available for:

  * S3 datasets using Parquet. This requires the additional s3fs package, as well as fastparquet or pyarrow

  * Snowflake datasets. This requires the additional snowflake-connector-python[pandas] package




Parameters:
    

  * **columns** (_list_) – List of columns to read, or None for all columns

  * **auto_fallback** (_boolean_) – If fast path is impossible and auto_fallback is True, then a regular `get_dataframe()` call will be used. If auto_fallback is False, this method will fail

  * **print_deep_memory_usage** (_bool_) – After reading the dataframe, Dataiku prints the memory usage of the dataframe. When this is enabled, this will provide the accurate memory usage, including for string columns. This can have a small performance impact. Defaults to True

  * **pandas_read_kwargs** (_dict_) – For the case where the read is mediated by a call to pd.read_parquet, arguments to pass to the read_parquet function




get_dataframe(_columns =None_, _sampling ='head'_, _sampling_column =None_, _limit =None_, _ratio =None_, _ascending =True_, _infer_with_pandas =True_, _parse_dates =True_, _bool_as_str =False_, _int_as_float =False_, _use_nullable_integers =False_, _categoricals =None_, _float_precision =None_, _na_values =None_, _keep_default_na =True_, _print_deep_memory_usage =True_, _skip_additional_data_checks =False_, _date_parser =None_, _override_dtypes =None_, _pandas_read_kwargs =None_)
    

Read the dataset (or its selected partitions, if applicable) as a Pandas dataframe.

Pandas dataframes are fully in-memory, so you need to make sure that your dataset will fit in RAM before using this.
    
    
    # read some dataset and print its shape
    dataset = dataiku.Dataset("the_dataset_name")
    df = dataset.get_dataframe()
    print("Number of rows: %s" df.shape[0])
    print("Number of columns: %s" df.shape[1])
    

Parameters:
    

  * **columns** (_list_) – when not None, returns only columns from the given list. defaults to None

  * **limit** (_integer_) – limits the number of rows returned, defaults to None

  * **sampling** – sampling method, see `dataiku.core.dataset.create_sampling_argument()`. Defaults to ‘head’.

  * **sampling_column** (_string_) – column used for “random-column” and “sort-column” sampling, defaults to None

  * **ratio** (_float_) – define the max row count as a ratio (between 0 and 1) of the dataset’s total row count

  * **boolean** (_ascending_) – sort in ascending order the selected column of the “sort-column” sampling, defaults to True

  * **infer_with_pandas** (_bool_) – uses the types detected by pandas rather than the dataset schema as detected in DSS, defaults to True

  * **parse_dates** (_bool_) – Only used when infer_with_pandas is False. Parses date column in DSS schema. Defaults to True

  * **bool_as_str** (_bool_) – Only used when infer_with_pandas is False. Leaves boolean values as string. Defaults to False

  * **int_as_float** (_bool_) – Only used when infer_with_pandas is False. Leaves int values as floats. Defaults to False

  * **use_nullable_integers** (_bool_) – Only used when infer_with_pandas is False. Use pandas nullable integer types, which allows missing values in integer columns

  * **categoricals** – Only used when infer_with_pandas is False. What columns to read as categoricals. This is particularly efficient for columns with low cardinality. Can be either “all_strings” to read all string columns as categorical, or a list of column names to read as categoricals

  * **float_precision** (_string_) – set Pandas converter, can be None, ‘high’, ‘legacy’ or ‘round_trip’, defaults to None. see [Pandas.read_table documentation](<https://pandas.pydata.org/>) for more information

  * **na_values** (_string/list/dict_) – 

additional strings to recognize as NA/NaN, defaults to None. see [Pandas.read_table documentation](<https://pandas.pydata.org/>) for more information

  * **keep_default_na** (_bool_) – 

whether or not to include the default NaN values when parsing the data, defaults to True. see [Pandas.read_table documentation](<https://pandas.pydata.org/>) for more information

  * **date_parser** (_function_) – 

function to use for converting a sequence of string columns to an array of datetime instances, defaults to None. see [Pandas.read_table documentation](<https://pandas.pydata.org/>) for more information

  * **skip_additional_data_checks** (_bool_) – Skip some data type checks. Enabling this can lead to strongly increased performance (up to x3). It is usually safe to enable this. Default to False

  * **print_deep_memory_usage** (_bool_) – After reading the dataframe, Dataiku prints the memory usage of the dataframe. When this is enabled, this will provide the accurate memory usage, including for string columns. This can have a small performnace impact. Defaults to True

  * **override_dtypes** (_dict_) – If not None, overrides dtypes computed from schema. Defaults to None

  * **pandas_read_kwargs** (_dict_) – If not None, additional kwargs passed to pd.read_table. Defaults to None



Returns:
    

a Pandas dataframe object

Return type:
    

`pandas.core.frame.DataFrame`

to_html(_columns =None_, _sampling ='head'_, _sampling_column =None_, _limit =None_, _ratio =None_, _apply_conditional_formatting =True_, _header =True_, _classes =''_, _border =0_, _null_string =''_, _indent_string =None_, _filter_expression =None_)
    

Render the dataset as an html table.

HTML tables are fully in-memory, so you need to make sure that your dataset will fit in RAM before using this, or pass a value to the limit parameter.
    
    
    # read some dataset and displays the first 50 rows
    dataset = dataiku.Dataset("the_dataset_name")
    df = dataset.to_html(limit=50)
    

Parameters:
    

  * **columns** (_list_ _[__str_ _]_) – when not None, returns only columns from the given list. Defaults to None

  * **sampling** – sampling method, see `dataiku.core.dataset.create_sampling_argument()`. Defaults to ‘head’.

  * **sampling_column** (_string_) – column used for “random-column” and “sort-column” sampling, defaults to None

  * **limit** (_integer_) – limits the number of rows returned, defaults to None

  * **ratio** (_float_) – define the max row count as a ratio (between 0 and 1) of the dataset’s total row count

  * **apply_conditional_formatting** (_bool_) – true to apply conditional formatting as it has been defined in DSS Explore view

  * **header** (_bool_) – Whether to print column labels, default True.

  * **classes** (_str_ _or_ _list_ _[__str_ _]_) – Name of the CSS class attached to TABLE tag in the generated HTML (or multiple classes as a list).

  * **border** (_int_) – A border attribute of the specified size is included in the opening <table> tag. Default to 0

  * **null_string** (_str_) – string to represent null values. Defaults to an empty string.

  * **indent_string** (_str_) – characters to use to indent the formatted HTML. If None or empty string, no indentation and no carriage return line feed. Defaults to None

  * **filter_expression** (_str_) – expression used to filter data using formula language, defaults to None. Not supported on datasets with preparation steps.



Returns:
    

an HTML representation of the dataset

Return type:
    

str

_static _get_dataframe_schema_st(_schema_ , _columns =None_, _parse_dates =True_, _infer_with_pandas =False_, _bool_as_str =False_, _int_as_float =False_, _use_nullable_integers =False_, _categoricals =None_)
    

Extract information for Pandas from a schema.

See `get_dataframe()` for explanation of the other parameters

Parameters:
    

**schema** (_list_ _[__dict_ _]_) – a schema definition as returned by `read_schema()`

Returns:
    

a list of 3 items:

  * a list columns names

  * a dict of columns Numpy data types by names

  * a list of the indexes of the dates columns or False




Return type:
    

tuple[list,dict,list]

iter_dataframes_forced_types(_names_ , _dtypes_ , _parse_date_columns_ , _chunksize =10000_, _sampling ='head'_, _sampling_column =None_, _limit =None_, _ratio =None_, _float_precision =None_, _na_values =None_, _keep_default_na =True_, _date_parser =None_, _ascending =True_, _pandas_read_kwargs =None_)
    

Read the dataset to Pandas dataframes by chunks of fixed size with given data types.
    
    
    import dataiku
    
    dataset = dataiku.Dataset("my_dataset")
    [names, dtypes, parse_date_columns] = dataiku.Dataset.get_dataframe_schema_st(dataset.read_schema())
    chunk = 0
    chunksize = 1000
    headsize = 5
    for df in dataset.iter_dataframes_forced_types(names, dtypes, parse_date_columns, chunksize = chunksize):
        print("> chunk #", chunk, "- first", headsize, "rows of", df.shape[0])
        chunk += 1
        print(df.head(headsize))
    

Parameters:
    

  * **names** (_list_ _[__string_ _]_) – list of column names

  * **dtypes** (_dict_) – dict of data types by columns name

  * **parse_date_columns** (_list_) – a list of the indexes of the dates columns or False

  * **chunksize** (_int_ _,__optional_) – chunk size, defaults to 10000

  * **limit** (_integer_) – limits the number of rows returned, defaults to None

  * **sampling** (_str_ _,__optional_) – sampling method, see `dataiku.core.dataset.create_sampling_argument()`. Defaults to ‘head’.

  * **sampling_column** (_string_ _,__optional_) – select the column used for “random-column” and “sort-column” sampling, defaults to None

  * **ratio** (_float_ _,__optional_) – define the max row count as a ratio (between 0 and 1) of the dataset’s total row count

  * **float_precision** (_string_ _,__optional_) – 

set Pandas converter, can be None, ‘high’, ‘legacy’ or ‘round_trip’, defaults to None. see [Pandas.read_table documentation](<https://pandas.pydata.org/>) for more information

  * **na_values** (_string/list/dict_ _,__optional_) – 

additional strings to recognize as NA/NaN, defaults to None. see [Pandas.read_table documentation](<https://pandas.pydata.org/>) for more information

  * **keep_default_na** (_bool_ _,__optional_) – 

whether or not to include the default NaN values when parsing the data, defaults to True. see [Pandas.read_table documentation](<https://pandas.pydata.org/>) for more information

  * **date_parser** (_function_ _,__optional_) – 

function to use for converting a sequence of string columns to an array of datetime instances, defaults to None. see [Pandas.read_table documentation](<https://pandas.pydata.org/>) for more information

  * **ascending** (_boolean_ _,__optional_) – sort in ascending order the selected column of the “sort-column” sampling, defaults to True

  * **pandas_read_kwargs** (_dict_) – If not None, additional kwargs passed to pd.read_table. Defaults to None



Yield:
    

`pandas.core.frame.DataFrame`

Return type:
    

generator

iter_dataframes(_chunksize =10000_, _infer_with_pandas =True_, _sampling ='head'_, _sampling_column =None_, _parse_dates =True_, _limit =None_, _ratio =None_, _columns =None_, _bool_as_str =False_, _int_as_float =False_, _use_nullable_integers =False_, _categoricals =None_, _float_precision =None_, _na_values =None_, _keep_default_na =True_, _ascending =True_, _pandas_read_kwargs =None_)
    

Read the dataset to Pandas dataframes by chunks of fixed size.

Tip

Useful is the dataset doesn’t fit in RAM
    
    
    import dataiku
    
    dataset = dataiku.Dataset("my_dataset")
    for df in dataset.iter_dataframes(chunksize = 5000):
        print("> chunk of", df.shape[0], "rows")
        print(df.head(headsize))
    

Parameters:
    

  * **chunksize** (_int_ _,__optional_) – chunk size, defaults to 10000

  * **infer_with_pandas** (_bool_ _,__optional_) – use the types detected by pandas rather than the dataset schema as detected in DSS, defaults to True

  * **limit** (_int_ _,__optional_) – limits the number of rows returned, defaults to None

  * **sampling** (_str_ _,__optional_) – sampling method, see `dataiku.core.dataset.create_sampling_argument()`. Defaults to ‘head’.

  * **sampling_column** (_string_ _,__optional_) – select the column used for “random-column” and “sort-column” sampling, defaults to None

  * **parse_dates** (_bool_ _,__optional_) – date column in DSS’s dataset schema are parsed, defaults to True

  * **limit** – set the sampling max rows count, defaults to None

  * **ratio** (_float_ _,__optional_) – define the max row count as a ratio (between 0 and 1) of the dataset’s total row count

  * **columns** (_list_ _[__str_ _]__,__optional_) – specify the desired columns, defaults to None (all columns)

  * **bool_as_str** (_bool_ _,__optional_) – Only used when infer_with_pandas is False. Leaves boolean values as strings, defaults to False

  * **int_as_float** (_bool_ _,__optional_) – Only used when infer_with_pandas is False. Leaves int values as floats. Defaults to False

  * **use_nullable_integers** (_bool_ _,__optional_) – Only used when infer_with_pandas is False. Use pandas nullable integer types, which allows missing values in integer columns. Defaults to False

  * **categoricals** (_string/list_ _,__optional_) – Only used when infer_with_pandas is False. What columns to read as categoricals. This is particularly efficient for columns with low cardinality. Can be either “all_strings” to read all string columns as categorical, or a list of column names to read as categoricals

  * **float_precision** (_string_ _,__optional_) – 

set Pandas converter, can be None, ‘high’, ‘legacy’ or ‘round_trip’, defaults to None. see [Pandas.read_table documentation](<https://pandas.pydata.org/>) for more information

  * **na_values** (_string/list/dict_ _,__optional_) – 

additional strings to recognize as NA/NaN, defaults to None. see [Pandas.read_table documentation](<https://pandas.pydata.org/>) for more information

  * **keep_default_na** (_bool_ _,__optional_) – 

whether or not to include the default NaN values when parsing the data, defaults to True. see [Pandas.read_table documentation](<https://pandas.pydata.org/>) for more information

  * **ascending** (_boolean_ _,__optional_) – sort in ascending order the selected column of the “sort-column” sampling, defaults to True

  * **pandas_read_kwargs** (_dict_) – If not None, additional kwargs passed to pd.read_table. Defaults to None



Yield:
    

`pandas.core.frame.DataFrame`

Return type:
    

generator

write_with_schema(_df_ , _drop_and_create =False_, _** kwargs_)
    

Write a pandas dataframe to this dataset (or its target partition, if applicable).

This variant replaces the schema of the output dataset with the schema of the dataframe.

Caution

strings MUST be in the dataframe as UTF-8 encoded str objects. Using unicode objects will fail.

Note

the dataset must be _writable_ , ie declared as an output, except if you instantiated the dataset with ignore_flow=True
    
    
    import dataiku
    from dataiku import recipe
    
    # simply copy the first recipe input dataset
    # to the first recipe output dataset, with the schema
    
    ds_input = recipe.get_inputs()[0]
    df_input = ds_input.get_dataframe()
    ds_output = recipe.get_outputs()[0]
    ds_output.write_with_schema(df_input, True)
    

Parameters:
    

  * **df** (`pandas.core.frame.DataFrame`) – a panda dataframe

  * **drop_and_create** (_bool_ _,__optional_) – whether to drop and recreate the dataset, defaults to False

  * **dropAndCreate** (_bool_ _,__optional_) – **deprecated** , use `drop_and_create`




write_dataframe(_df_ , _infer_schema =False_, _drop_and_create =False_, _** kwargs_)
    

Write a pandas dataframe to this dataset (or its target partition, if applicable).

This variant only edits the schema if infer_schema is True, otherwise you need to only write dataframes that have a compatible schema. Also see `write_with_schema()`.

Caution

strings MUST be in the dataframe as UTF-8 encoded str objects. Using unicode objects will fail.

Note

the dataset must be _writable_ , ie declared as an output, except if you instantiated the dataset with ignore_flow=True

Parameters:
    

  * **df** (`pandas.core.frame.DataFrame`) – a pandas dataframe

  * **infer_schema** (_bool_ _,__optional_) – whether to infer the schema from the dataframe, defaults to False

  * **drop_and_create** (_bool_ _,__optional_) – whether to drop and recreate the dataset, defaults to False

  * **dropAndCreate** (_bool_ _,__optional_) – **deprecated** , use `drop_and_create`




iter_rows(_sampling ='head'_, _sampling_column =None_, _limit =None_, _ratio =None_, _log_every =-1_, _timeout =30_, _columns =None_, _ascending =True_)
    

Get a generator of rows (as a dict-like object) in the data (or its selected partitions, if applicable).

Values are cast according to their types. String are parsed into “unicode” values.

Parameters:
    

  * **limit** (_int_ _,__optional_) – limits the number of rows returned, defaults to None

  * **sampling** (_str_ _,__optional_) – sampling method, see `dataiku.core.dataset.create_sampling_argument()`. Defaults to ‘head’.

  * **sampling_column** (_string_ _,__optional_) – select the column used for “random-column” and “sort-column” sampling, defaults to None

  * **limit** – maximum number of rows to be emitted, defaults to None

  * **ratio** (_float_ _,__optional_) – define the max row count as a ratio (between 0 and 1) of the dataset’s total row count

  * **log_every** (_int_ _,__optional_) – print out the number of rows read on stdout, defaults to -1 (no log)

  * **timeout** (_int_ _,__optional_) – set a timeout in seconds, defaults to 30

  * **columns** (_list_ _[__str_ _]__,__optional_) – specify the desired columns, defaults to None (all columns)

  * **ascending** (_boolean_ _,__optional_) – sort in ascending order the selected column of the “sort-column” sampling, defaults to True



Yield:
    

`dataiku.core.dataset.DatasetCursor`

Return type:
    

generator

raw_formatted_data(_sampling =None_, _columns =None_, _format ='tsv-excel-noheader'_, _format_params =None_, _read_session_id =None_, _filter_expression =None_)
    

Get a stream of raw bytes from a dataset as a file-like object, formatted in a supported DSS output format.

Caution

You MUST close the file handle. Failure to do so will result in resource leaks.

After closing, you can also call `verify_read()` to check for any errors that occurred while reading the dataset data.
    
    
    import uuid
    import dataiku
    from dataiku.core.dataset import create_sampling_argument
    
    dataset = dataiku.Dataset("customers_partitioned")
    read_session_id = str(uuid.uuid4())
    sampling = create_sampling_argument(sampling='head', limit=5)
    resp = dataset.raw_formatted_data(sampling=sampling, format="json", read_session_id=read_session_id)
    print(resp.data)
    resp.close()
    dataset.verify_read(read_session_id) #throw an exception if the read hasn't been fully completed
    print("read completed successfully")
    

Parameters:
    

  * **sampling** (_dict_ _,__optional_) – a dict of sampling specs, see `dataiku.core.dataset.create_sampling_argument()`, defaults to None

  * **columns** (_list_ _[__str_ _]__,__optional_) – list of desired columns, defaults to None (all columns)

  * **format** (_str_ _,__optional_) – output format, defaults to “tsv-excel-noheader”. Supported formats are : “json”, “tsv-excel-header” (tab-separated with header) and “tsv-excel-noheader” (tab-separated without header)

  * **format_params** (_dict_ _,__optional_) – dict of output format parameters, defaults to None

  * **read_session_id** (_str_ _,__optional_) – identifier of the read session, used to check at the end if the read was successful, defaults to None

  * **filter_expression** (_str_ _,__optional_) – expression used to filter data using formula language, defaults to None



Returns:
    

an HTTP response

Return type:
    

`urllib3.response.HTTPResponse`

verify_read(_read_session_id_)
    

Verify that no error occurred when using `raw_formatted_data()` to read a dataset.

Use the same read_session_id that you passed to the call to `raw_formatted_data()`.

Parameters:
    

**read_session_id** (_str_) – identifier of the read session

Raises:
    

**Exception** – if an error occured while the read

iter_tuples(_sampling ='head'_, _sampling_column =None_, _limit =None_, _ratio =None_, _log_every =-1_, _timeout =30_, _columns =None_, _ascending =True_)
    

Get the rows of the dataset as tuples.

The order and type of the values are the same are matching the dataset’s parameter

Values are cast according to their types. String are parsed into “unicode” values.

Parameters:
    

  * **limit** (_int_ _,__optional_) – limits the number of rows returned, defaults to None

  * **sampling** (_str_ _,__optional_) – sampling method, see `dataiku.core.dataset.create_sampling_argument()`. Defaults to ‘head’.

  * **sampling_column** (_string_ _,__optional_) – select the column used for “random-column” and “sort-column” sampling, defaults to None

  * **limit** – maximum number of rows to be emitted, defaults to None (all)

  * **ratio** (_float_ _,__optional_) – define the max row count as a ratio (between 0 and 1) of the dataset’s total row count

  * **log_every** (_int_ _,__optional_) – print out the number of rows read on stdout, defaults to -1 (no log)

  * **timeout** (_int_ _,__optional_) – time (in seconds) of inactivity after which we want to close the generator if nothing has been read. Without it notebooks typically tend to leak “DKU” processes, defaults to 30

  * **columns** (_list_ _[__str_ _]__,__optional_) – list of desired columns, defaults to None (all columns)

  * **ascending** (_boolean_ _,__optional_) – sort in ascending order the selected column of the “sort-column” sampling, defaults to True



Yield:
    

a tuples of columns values

Return type:
    

generator

get_writer()
    

Get a stream writer for this dataset (or its target partition, if applicable).

Caution

The writer must be closed as soon as you don’t need it.

Returns:
    

a stream writer

Return type:
    

`dataiku.core.dataset_write.DatasetWriter`

get_continuous_writer(_source_id_ , _split_id =0_)
    

Get a stream writer for this dataset (or its target partition, if applicable).
    
    
    dataset = dataiku.Dataset("wikipedia_dataset")
    dataset.write_schema([{"name":"data", "type":"string"}, ...])
    with dataset.get_continuous_writer(...) as writer:
        for msg in message_iterator:
            writer.write_row_dict({"data":msg.data, ...})
            writer.checkpoint("this_recipe", "some state")
    

Parameters:
    

  * **source_id** (_str_) – identifier of the source of the stream

  * **split_id** (_int_ _,__optional_) – split id in the output (for concurrent usage), defaults to 0



Returns:
    

a stream writer

Return type:
    

`dataiku.core.continuous_write.DatasetContinuousWriter`

write_schema(_columns_ , _drop_and_create =False_, _** kwargs_)
    

Write the dataset schema into the dataset JSON definition file.

Sometimes, the schema of a dataset being written is known only by the code of the Python script itself. In that case, it can be useful for the Python script to actually modify the schema of the dataset.

Caution

Obviously, this must be used with caution.

Parameters:
    

  * **columns** (_list_) – see `read_schema()`

  * **drop_and_create** (_bool_ _,__optional_) – whether to drop and recreate the dataset, defaults to False

  * **dropAndCreate** (_bool_ _,__optional_) – **deprecated** , use `drop_and_create`




write_schema_from_dataframe(_df_ , _drop_and_create =False_, _** kwargs_)
    

Set the schema of this dataset to the schema of a Pandas dataframe.
    
    
    import dataiku
    
    input_ds = dataiku.Dataset("input_dataset")
    my_input_dataframe = input_ds.get_dataframe()
    output_ds = dataiku.Dataset("output_dataset")
    
    # Set the schema of "output_ds" to match the columns of "my_input_dataframe"
    output_ds.write_schema_from_dataframe(my_input_dataframe)
    

Parameters:
    

  * **df** (`pandas.core.frame.DataFrame`) – a Pandas dataframe

  * **drop_and_create** (_bool_ _,__optional_) – whether drop and recreate the dataset, defaults to False

  * **dropAndCreate** (_bool_ _,__optional_) – **deprecated** , use `drop_and_create`




read_metadata()
    

Get the metadata attached to this dataset.

The metadata contains label, description checklists, tags and custom metadata of the dataset

Returns:
    

the metadata as a dict, with fields:

  * **label** : label of the object (not defined for recipes)

  * **description** : description of the object (not defined for recipes)

  * **checklists** : checklists of the object, as a dict with a **checklists** field, which is a list of checklists, each a dict of fields:

>     * **id** : identifier of the checklist
> 
>     * **title** : label of the checklist
> 
>     * **createdBy** : user who created the checklist
> 
>     * **createdOn** : timestamp of creation, in milliseconds
> 
>     * **items** : list of the items in the checklist, each a dict of
>
>>       * **done** : True if the item has been done
>> 
>>       * **text** : label of the item
>> 
>>       * **createdBy** : who created the item
>> 
>>       * **createdOn** : when the item was created, as a timestamp in milliseconds
>> 
>>       * **stateChangedBy** : who ticked the item as done (or not done)
>> 
>>       * **stateChangedOn** : when the item was last changed to done (or not done), as a timestamp in milliseconds

  * **tags** : list of tags, each a string

  * **custom** : custom metadata, as a dict with a **kv** field, which is a dict with any contents the user wishes

  * **customFields** : dict of custom field info (not defined for recipes)




Return type:
    

dict

write_metadata(_meta_)
    

Write the metadata to the dataset.

Note

you should set a metadata that you obtained via `read_metadata()` then modified.

Parameters:
    

**meta** (_dict_) – metadata specifications as dict, see `read_metadata()`

get_config()
    

Get the dataset config.

Returns:
    

all dataset settings, with many relative to its type. main settings keys are:

  * **type** : type of the dataset such as “PostgreSQL”, “Filesystem”, etc…

  * **name** : name of the dataset

  * **projectKey** : project hosting the dataset

  * **schema** : dataset schema as dict with ‘columns’ definition

  * **partitioning** : partitions settings as dict

  * **managed** : True if the dataset is managed

  * **readWriteOptions** : dict of read or write options

  * **versionTag** : version info as dict with ‘versionNumber’, ‘lastModifiedBy’, and ‘lastModifiedOn’

  * **creationTag** : creation info as dict with ‘versionNumber’, ‘lastModifiedBy’, and ‘lastModifiedOn’

  * **tags** : list of tags

  * **metrics** : dict with a list of probes, see [Metrics and checks](<metrics.html>)




Return type:
    

dict

get_last_metric_values(_partition =''_)
    

Get the set of last values of the metrics on this dataset.

Parameters:
    

**partition** (_string_) – (optional), the partition for which to fetch the values. On partitioned datasets, the partition value to use for accessing metrics on the whole dataset (ie. all partitions) is ALL

Return type:
    

[`dataiku.core.metrics.ComputedMetrics`](<metrics.html#dataiku.core.metrics.ComputedMetrics> "dataiku.core.metrics.ComputedMetrics")

get_metric_history(_metric_lookup_ , _partition =''_)
    

Get the set of all values a given metric took on this dataset.

Parameters:
    

  * **metric_lookup** (_string_) – metric name or unique identifier

  * **partition** (_string_) – (optional), the partition for which to fetch the values. On partitioned datasets, the partition value to use for accessing metrics on the whole dataset (ie. all partitions) is ALL



Return type:
    

dict

save_external_metric_values(_values_dict_ , _partition =''_)
    

Save metrics on this dataset.

The metrics are saved with the type “external”.

Parameters:
    

  * **values_dict** (_dict_) – the values to save, as a dict. The keys of the dict are used as metric names

  * **partition** (_string_) – (optional), the partition for which to save the values. On partitioned datasets, the partition value to use for accessing metrics on the whole dataset (ie. all partitions) is ALL



Return type:
    

dict

get_last_check_values(_partition =''_)
    

Get the set of last values of the checks on this dataset.

Parameters:
    

**partition** (_string_) – (optional), the partition for which to fetch the values. On partitioned datasets, the partition value to use for accessing metrics on the whole dataset (ie. all partitions) is ALL

Return type:
    

[`dataiku.core.metrics.ComputedChecks`](<metrics.html#dataiku.core.metrics.ComputedChecks> "dataiku.core.metrics.ComputedChecks")

save_external_check_values(_values_dict_ , _partition =''_)
    

Save checks on this dataset.

The checks are saved with the type “external”

Parameters:
    

  * **values_dict** (_dict_) – the values to save, as a dict. The keys of the dict are used as check names

  * **partition** (_string_) – (optional), the partition for which to save the values. On partitioned datasets, the partition value to use for accessing metrics on the whole dataset (ie. all partitions) is ALL



Return type:
    

dict

dataset.create_sampling_argument(_sampling_column =None_, _limit =None_, _ratio =None_, _ascending =True_)
    

Generate sampling parameters. Please see <https://doc.dataiku.com/dss/latest/explore/sampling.html#sampling-methods> for more information.

Parameters:
    

  * **sampling** (_str_ _,__optional_) – sampling method, see `dataiku.core.dataset.create_sampling_argument()`. Defaults to ‘head’.

  * **sampling_column** (_string_ _,__optional_) – select the column used for “random-column” and “sort-column” sampling, defaults to None

  * **limit** (_int_ _,__optional_) – set the sampling max rows count, defaults to None

  * **ratio** (_float_ _,__optional_) – define the max row count as a ratio (between 0 and 1) of the dataset’s total row count

  * **ascending** (_boolean_ _,__optional_) – sort in ascending order the selected column of the “sort-column” sampling, defaults to True



Returns:
    

sampling parameters

Return type:
    

dict

_class _dataiku.core.dataset_write.DatasetWriter(_dataset_)
    

Handle to write to a dataset.

Important

Do not instantiate directly, use `dataiku.Dataset.get_writer()` instead.

Attention

An instance of `DatasetWriter` MUST be closed after usage. Failure to close it will lead to incomplete or no data being written to the output dataset

active_writers _ = {}_
    

_static _atexit_handler()
    

write_tuple(_row_)
    

Write a single row from a tuple or list of column values.

Columns must be given in the order of the dataset schema. Strings MUST be given as Unicode object. Giving str objects will fail.

Note

The schema of the dataset MUST be set before using this.

Parameters:
    

**row** (_list_) – a list of values, one per column in the output schema. Columns cannot be omitted.

write_row_array(_row_)
    

Write a single row from an array.

Caution

Deprecated, use `write_tuple()`

write_row_dict(_row_dict_)
    

Write a single row from a dict of column name -> column value.

Some columns can be omitted, empty values will be inserted instead. Strings MUST be given as Unicode object. Giving str objects will fail.

Note

The schema of the dataset MUST be set before using this.

Parameters:
    

**row_dict** (_dict_) – a dict of column name to column value

write_dataframe(_df_)
    

Append a Pandas dataframe to the dataset being written.

This method can be called multiple times (especially when you have been using `dataiku.Dataset.iter_dataframes()` to read from an input dataset).

Strings MUST be in the dataframe as UTF-8 encoded str objects. Using unicode objects will fail.

Parameters:
    

**df** (_DataFrame_) – a Pandas dataframe

close()
    

Close this dataset writer.

_class _dataiku.core.dataset.Schema(_data_)
    

List of the definitions of the columns in a dataset.

Each column definition is a dict with at least a **name** field and a **type** field. Available columns types include:

type | note | sample value  
---|---|---  
string |  | b’foobar’  
bigint | 64 bits | 9223372036854775807  
int | 32 bits | 2147483647  
smallint | 16 bits | 32767  
tinyint | 8 bits | 127  
double | 64 bits | 3.1415  
float | 32 bits | 3.14  
boolean | 32 bits | true  
date | string | “2020-12-31T00:00:00.101Z”  
datetimenotz | string | “2020-12-31 00:00:00.101”  
dateonly | string | “2020-12-31”  
array | json string | ‘[“foo”,”bar”]’  
map | json string | ‘{“foo”:”bar”}’  
object | json string | ‘{“foo”:{“bar”:[1,2,3]}}’  
geopoint | string | “POINT(12 24)”  
geometry | string | “POLYGON((1.1 1.1, 2.1 0, 0.1 0))”  
  
Each column definition has fields:

>   * **name** : name of the column as string
> 
>   * **type** : type of the column as string
> 
>   * **maxLength** : maximum length of values (when applicable, typically for string)
> 
>   * **comment** : user comment on the column
> 
>   * **timestampNoTzAsDate** : for columns of type “date” in non-managed datasets, whether the actual type in the underlying SQL database or file bears timezone information
> 
>   * **originalType** and **originalSQLType** : for columns in non-managed datasets, the name of the column type in the underlying SQL database or file
> 
>   * **arrayContent** : for array-typed columns, a column definition that applies to all elements in the array
> 
>   * **mapKeys** and **mapValues** : for map-types columns, a column definition that applies to all keys (resp. values) in the map
> 
>   * **objectFields** : for object-typed columns, a list of column definitions for the sub-fields in the object
> 
> 


_class _dataiku.core.dataset.DatasetCursor(_val_ , _col_names_ , _col_idx_)
    

A dataset cursor iterating on the rows.

Caution

you should not instantiate it manually, see `dataiku.Dataset.iter_rows()`

column_id(_name_)
    

Get a column index from its name.

Parameters:
    

**name** (_str_) – column name

Returns:
    

the column index

Return type:
    

int

keys()
    

Get the set of column names.

Returns:
    

list of columns name

Return type:
    

list[str]

items()
    

Get the full row.

Returns:
    

a list of tuple (column, value)

Return type:
    

list[tuple]

values()
    

Get values in the row.

Returns:
    

list of columns values

Return type:
    

list

get(_col_name_ , _default_value =None_)
    

Get a value by its column name.

Parameters:
    

  * **col_name** (_str_) – a column name

  * **default_value** (_str_ _,__optional_) – value to return if the column is not present, defaults to None



Returns:
    

the value of the column

Return type:
    

depends on the column’s type

## The dataikuapi.dss.dataset package

### Main DSSDataset class

_class _dataikuapi.dss.dataset.DSSDataset(_client_ , _project_key_ , _dataset_name_)
    

A dataset on the DSS instance. Do not instantiate this class, use [`dataikuapi.dss.project.DSSProject.get_dataset()`](<projects.html#dataikuapi.dss.project.DSSProject.get_dataset> "dataikuapi.dss.project.DSSProject.get_dataset")

_property _id
    

Get the dataset identifier.

Return type:
    

string

_property _name
    

Get the dataset name.

Return type:
    

string

delete(_drop_data =False_)
    

Delete the dataset.

Parameters:
    

**drop_data** (_bool_) – Should the data of the dataset be dropped, defaults to False

rename(_new_name_)
    

Rename the dataset with the new specified name

Parameters:
    

**new_name** (_str_) – the new name of the dataset

get_settings()
    

Get the settings of this dataset as a `DSSDatasetSettings`, or one of its subclasses.

Know subclasses of `DSSDatasetSettings` include `FSLikeDatasetSettings` and `SQLDatasetSettings`

You must use `save()` on the returned object to make your changes effective on the dataset.
    
    
    # Example: activating discrete partitioning on a SQL dataset
    dataset = project.get_dataset("my_database_table")
    settings = dataset.get_settings()
    settings.add_discrete_partitioning_dimension("country")
    settings.save()
    

Return type:
    

`DSSDatasetSettings`

get_definition()
    

Get the raw settings of the dataset as a dict.

Caution

Deprecated. Use `get_settings()`

Return type:
    

dict

set_definition(_definition_)
    

Set the definition of the dataset

Caution

Deprecated. Use `get_settings()` and `DSSDatasetSettings.save()`

Parameters:
    

**definition** (_dict_) – the definition, as a dict. You should only set a definition object that has been retrieved using the `get_definition()` call.

exists()
    

Test if the dataset exists.

Returns:
    

whether this dataset exists

Return type:
    

bool

get_schema()
    

Get the dataset schema.

Returns:
    

a dict object of the schema, with the list of columns.

Return type:
    

dict

set_schema(_schema_)
    

Set the dataset schema.

Parameters:
    

**schema** (_dict_) – the desired schema for the dataset, as a dict. All columns have to provide their name and type.

get_metadata()
    

Get the metadata attached to this dataset. The metadata contains label, description checklists, tags and custom metadata of the dataset

Returns:
    

a dict object. For more information on available metadata, please see <https://doc.dataiku.com/dss/api/latest/rest/>

Return type:
    

dict

set_metadata(_metadata_)
    

Set the metadata on this dataset.

Parameters:
    

**metadata** (_dict_) – the new state of the metadata for the dataset. You should only set a metadata object that has been retrieved using the `get_metadata()` call.

generate_ai_description(_language ='english'_, _save_description =False_)
    

Generates AI-powered descriptions for this dataset and its columns.

This function operates with a two-tier rate limit per license:
    

  1. Up to 1000 requests per day.

  2. **Throttled Mode:** After the daily limit, the API’s response time is slowed. 
    

Each subsequent call will take approximately 60 seconds to process and return a response.




Note: The “Generate Metadata” option must be enabled in the AI Services admin settings.

Parameters:
    

  * **language** (_str_) – The language of the generated description. Supported languages are “dutch”, “english”, “french”, “german”, “portuguese”, and “spanish” (defaults to **english**).

  * **save_description** (_bool_) – To save the generated description to this dataset (defaults to **False**).



Returns:
    

a dict object of the dataset schema and descriptions.

Return type:
    

dict

iter_rows(_partitions =None_)
    

Get the dataset data as a row-by-row iterator.

Parameters:
    

**partitions** (_Union_ _[__string_ _,__list_ _[__string_ _]__]_) – (optional) partition identifier, or list of partitions to include, if applicable.

Returns:
    

an iterator over the rows, each row being a list of values. The order of values in the list is the same as the order of columns in the schema returned by `get_schema()`

Return type:
    

generator[list]

list_partitions()
    

Get the list of all partitions of this dataset.

Returns:
    

the list of partitions, as a list of strings.

Return type:
    

list[string]

clear(_partitions =None_)
    

Clear data in this dataset.

Parameters:
    

**partitions** (_Union_ _[__string_ _,__list_ _[__string_ _]__]_) – (optional) partition identifier, or list of partitions to clear. When not provided, the entire dataset is cleared.

Returns:
    

a dict containing the method call status.

Return type:
    

dict

copy_to(_target_ , _sync_schema =True_, _write_mode ='OVERWRITE'_)
    

Copy the data of this dataset to another dataset.

Parameters:
    

  * **target** (`dataikuapi.dss.dataset.DSSDataset`) – an object representing the target of this copy.

  * **sync_schema** (_bool_) – (optional) update the target dataset schema to make it match the sourece dataset schema.

  * **write_mode** (_string_) – (optional) OVERWRITE (default) or APPEND. If OVERWRITE, the output dataset is cleared prior to writing the data.



Returns:
    

a DSSFuture representing the operation.

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

search_data_elastic(_query_string_ , _start =0_, _size =128_, _sort_columns =None_, _partitions =None_)
    

Caution

Only for datasets on Elasticsearch connections

Query the service with a search string to directly fetch data

Parameters:
    

  * **query_string** (_str_) – Elasticsearch compatible query string

  * **start** (_int_) – row to start fetching the data

  * **size** (_int_) – number of results to return

  * **sort_columns** (_list_) – list of {“column”, “order”} dict, which is the order to fetch data. “order” is “asc” for ascending, “desc” for descending

  * **partitions** (_list_) – if the dataset is partitioned, a list of partition ids to search



Returns:
    

a dict containing “columns”, “rows”, “warnings”, “found” (when start == 0)

Return type:
    

dict

build(_job_type ='NON_RECURSIVE_FORCED_BUILD'_, _partitions =None_, _wait =True_, _no_fail =False_)
    

Start a new job to build this dataset and wait for it to complete. Raises if the job failed.
    
    
    job = dataset.build()
    print("Job %s done" % job.id)
    

Parameters:
    

  * **job_type** – the job type. One of RECURSIVE_BUILD, NON_RECURSIVE_FORCED_BUILD or RECURSIVE_FORCED_BUILD

  * **partitions** – if the dataset is partitioned, a list of partition ids to build

  * **wait** (_bool_) – whether to wait for the job completion before returning the job handle, defaults to True

  * **no_fail** – if True, does not raise if the job failed.



Returns:
    

the [`dataikuapi.dss.job.DSSJob`](<jobs.html#dataikuapi.dss.job.DSSJob> "dataikuapi.dss.job.DSSJob") job handle corresponding to the built job

Return type:
    

[`dataikuapi.dss.job.DSSJob`](<jobs.html#dataikuapi.dss.job.DSSJob> "dataikuapi.dss.job.DSSJob")

synchronize_hive_metastore()
    

Synchronize this dataset with the Hive metastore

update_from_hive()
    

Resynchronize this dataset from its Hive definition

compute_metrics(_partition =''_, _metric_ids =None_, _probes =None_)
    

Compute metrics on a partition of this dataset.

If neither metric ids nor custom probes set are specified, the metrics setup on the dataset are used.

Parameters:
    

  * **partition** (_string_) – (optional) partition identifier, use ALL to compute metrics on all data.

  * **metric_ids** (_list_ _[__string_ _]_) – (optional) ids of the metrics to build



Returns:
    

a metric computation report, as a dict

Return type:
    

dict

run_checks(_partition =''_, _checks =None_)
    

Run checks on a partition of this dataset.

If the checks are not specified, the checks setup on the dataset are used.

Caution

Deprecated. Use [`dataikuapi.dss.data_quality.DSSDataQualityRuleSet.compute_rules()`](<data-quality.html#dataikuapi.dss.data_quality.DSSDataQualityRuleSet.compute_rules> "dataikuapi.dss.data_quality.DSSDataQualityRuleSet.compute_rules") instead

Parameters:
    

  * **partition** (_str_) – (optional) partition identifier, use ALL to run checks on all data.

  * **checks** (_list_ _[__string_ _]_) – (optional) ids of the checks to run.



Returns:
    

a checks computation report, as a dict.

Return type:
    

dict

uploaded_add_file(_fp_ , _filename_)
    

Add a file to an “uploaded files” dataset

Parameters:
    

  * **fp** (_file_) – A file-like object that represents the file to upload

  * **filename** (_str_) – The filename for the file to upload




uploaded_list_files()
    

List the files in an “uploaded files” dataset.

Returns:
    

uploaded files metadata as a list of dicts, with one dict per file.

Return type:
    

list[dict]

create_prediction_ml_task(_target_variable_ , _ml_backend_type ='PY_MEMORY'_, _guess_policy ='DEFAULT'_, _prediction_type =None_, _wait_guess_complete =True_)
    

Creates a new prediction task in a new visual analysis lab for a dataset.

Parameters:
    

  * **target_variable** (_str_) – the variable to predict

  * **ml_backend_type** (_str_) – ML backend to use, one of PY_MEMORY, MLLIB or H2O (defaults to **PY_MEMORY**)

  * **guess_policy** (_str_) – Policy to use for setting the default parameters. Valid values are: DEFAULT, SIMPLE_FORMULA, DECISION_TREE, EXPLANATORY and PERFORMANCE (defaults to **DEFAULT**)

  * **prediction_type** (_str_) – The type of prediction problem this is. If not provided the prediction type will be guessed. Valid values are: BINARY_CLASSIFICATION, REGRESSION, MULTICLASS (defaults to **None**)

  * **wait_guess_complete** (_boolean_) – if False, the returned ML task will be in ‘guessing’ state, i.e. analyzing the input dataset to determine feature handling and algorithms (defaults to **True**). You should wait for the guessing to be completed by calling **wait_guess_complete** on the returned object before doing anything else (in particular calling **train** or **get_settings**)



Returns:
    

A ML task handle of type ‘PREDICTION’

Return type:
    

[`dataikuapi.dss.ml.DSSMLTask`](<ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask")

create_clustering_ml_task(_input_dataset_ , _ml_backend_type ='PY_MEMORY'_, _guess_policy ='KMEANS'_, _wait_guess_complete =True_)
    

Creates a new clustering task in a new visual analysis lab for a dataset.

The returned ML task will be in ‘guessing’ state, i.e. analyzing the input dataset to determine feature handling and algorithms.

You should wait for the guessing to be completed by calling **wait_guess_complete** on the returned object before doing anything else (in particular calling **train** or **get_settings**)

Parameters:
    

  * **input_dataset** (_string_) – The dataset to use for training/testing the model

  * **ml_backend_type** (_str_) – ML backend to use, one of PY_MEMORY, MLLIB or H2O (defaults to **PY_MEMORY**)

  * **guess_policy** (_str_) – Policy to use for setting the default parameters. Valid values are: KMEANS and ANOMALY_DETECTION (defaults to **KMEANS**)

  * **wait_guess_complete** (_boolean_) – if False, the returned ML task will be in ‘guessing’ state, i.e. analyzing the input dataset to determine feature handling and algorithms (defaults to **True**). You should wait for the guessing to be completed by calling **wait_guess_complete** on the returned object before doing anything else (in particular calling **train** or **get_settings**)



Returns:
    

A ML task handle of type ‘CLUSTERING’

Return type:
    

[`dataikuapi.dss.ml.DSSMLTask`](<ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask")

create_timeseries_forecasting_ml_task(_target_variable_ , _time_variable_ , _timeseries_identifiers =None_, _guess_policy ='TIMESERIES_DEFAULT'_, _wait_guess_complete =True_)
    

Creates a new time series forecasting task in a new visual analysis lab for a dataset.

Parameters:
    

  * **target_variable** (_string_) – The variable to forecast

  * **time_variable** (_string_) – Column to be used as time variable. Should be a Date (parsed) column.

  * **timeseries_identifiers** (_list_) – List of columns to be used as time series identifiers (when the dataset has multiple series)

  * **guess_policy** (_string_) – Policy to use for setting the default parameters. Valid values are: TIMESERIES_DEFAULT, TIMESERIES_STATISTICAL, and TIMESERIES_DEEP_LEARNING

  * **wait_guess_complete** (_boolean_) – If False, the returned ML task will be in ‘guessing’ state, i.e. analyzing the input dataset to determine feature handling and algorithms. You should wait for the guessing to be completed by calling `wait_guess_complete` on the returned object before doing anything else (in particular calling `train` or `get_settings`)



Returns:
    

A ML task handle of type ‘PREDICTION’

Return type:
    

[`dataikuapi.dss.ml.DSSMLTask`](<ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask")

create_causal_prediction_ml_task(_outcome_variable_ , _treatment_variable_ , _prediction_type =None_, _wait_guess_complete =True_)
    

Creates a new causal prediction task in a new visual analysis lab for a dataset.

Parameters:
    

  * **outcome_variable** (_string_) – The outcome variable to predict.

  * **treatment_variable** (_string_) – The treatment variable.

  * **prediction_type** (_string_ _or_ _None_) – Valid values are: “CAUSAL_BINARY_CLASSIFICATION”, “CAUSAL_REGRESSION” or None (in this case prediction_type will be set by the Guesser)

  * **wait_guess_complete** (_boolean_) – If False, the returned ML task will be in ‘guessing’ state, i.e. analyzing the input dataset to determine feature handling and algorithms. You should wait for the guessing to be completed by calling `wait_guess_complete` on the returned object before doing anything else (in particular calling `train` or `get_settings`)



Returns:
    

A ML task handle of type ‘PREDICTION’

Return type:
    

[`dataikuapi.dss.ml.DSSMLTask`](<ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask")

create_analysis()
    

Create a new visual analysis lab for the dataset.

Returns:
    

A visual analysis handle

Return type:
    

`dataikuapi.dss.analysis.DSSAnalysis`

list_analyses(_as_type ='listitems'_)
    

List the visual analyses on this dataset

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects”, defaults to “listitems”

Returns:
    

The list of the analyses. If “as_type” is “listitems”, each one as a dict, If “as_type” is “objects”, each one as a `dataikuapi.dss.analysis.DSSAnalysis`

Return type:
    

list

delete_analyses(_drop_data =False_)
    

Delete all analyses that have this dataset as input dataset. Also deletes ML tasks that are part of the analysis

Parameters:
    

**drop_data** (_bool_) – whether to drop data for all ML tasks in the analysis, defaults to False

list_statistics_worksheets(_as_objects =True_)
    

List the statistics worksheets associated to this dataset.

Parameters:
    

**as_objects** (_bool_) – if true, returns the statistics worksheets as [`dataikuapi.dss.statistics.DSSStatisticsWorksheet`](<statistics.html#dataikuapi.dss.statistics.DSSStatisticsWorksheet> "dataikuapi.dss.statistics.DSSStatisticsWorksheet"), else as a list of dicts

Return type:
    

list of [`dataikuapi.dss.statistics.DSSStatisticsWorksheet`](<statistics.html#dataikuapi.dss.statistics.DSSStatisticsWorksheet> "dataikuapi.dss.statistics.DSSStatisticsWorksheet")

create_statistics_worksheet(_name ='My worksheet'_)
    

Create a new worksheet in the dataset, and return a handle to interact with it.

Parameters:
    

**name** (_string_) – name of the worksheet

Returns:
    

a statistic worksheet handle

Return type:
    

[`dataikuapi.dss.statistics.DSSStatisticsWorksheet`](<statistics.html#dataikuapi.dss.statistics.DSSStatisticsWorksheet> "dataikuapi.dss.statistics.DSSStatisticsWorksheet")

get_statistics_worksheet(_worksheet_id_)
    

Get a handle to interact with a statistics worksheet

Parameters:
    

**worksheet_id** (_string_) – the ID of the desired worksheet

Returns:
    

a statistic worksheet handle

Return type:
    

[`dataikuapi.dss.statistics.DSSStatisticsWorksheet`](<statistics.html#dataikuapi.dss.statistics.DSSStatisticsWorksheet> "dataikuapi.dss.statistics.DSSStatisticsWorksheet")

get_last_metric_values(_partition =''_)
    

Get the last values of the metrics on this dataset

Parameters:
    

**partition** (_string_) – (optional) partition identifier, use ALL to retrieve metric values on all data.

Returns:
    

a list of metric objects and their value

Return type:
    

[`dataikuapi.dss.metrics.ComputedMetrics`](<metrics.html#dataikuapi.dss.metrics.ComputedMetrics> "dataikuapi.dss.metrics.ComputedMetrics")

get_metric_history(_metric_ , _partition =''_)
    

Get the history of the values of the metric on this dataset

Parameters:
    

  * **metric** (_string_) – id of the metric to get

  * **partition** (_string_) – (optional) partition identifier, use ALL to retrieve metric history on all data.



Returns:
    

a dict containing the values of the metric, cast to the appropriate type (double, boolean,…)

Return type:
    

dict

get_info()
    

Retrieve all the information about a dataset

Returns:
    

a `DSSDatasetInfo` containing all the information about a dataset.

Return type:
    

`DSSDatasetInfo`

get_zone()
    

Get the flow zone of this dataset

Return type:
    

[`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone")

move_to_zone(_zone_)
    

Move this object to a flow zone

Parameters:
    

**zone** (_object_) – a [`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone") where to move the object

share_to_zone(_zone_)
    

Share this object to a flow zone

Parameters:
    

**zone** (_object_) – a [`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone") where to share the object

unshare_from_zone(_zone_)
    

Unshare this object from a flow zone

Parameters:
    

**zone** (_object_) – a [`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone") from where to unshare the object

get_usages()
    

Get the recipes or analyses referencing this dataset

Returns:
    

a list of usages

Return type:
    

list[dict]

get_object_discussions()
    

Get a handle to manage discussions on the dataset

Returns:
    

the handle to manage discussions

Return type:
    

[`dataikuapi.dss.discussion.DSSObjectDiscussions`](<discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions")

test_and_detect(_infer_storage_types =False_)
    

Used internally by `autodetect_settings()` It is not usually required to call this method

Parameters:
    

**infer_storage_types** (_bool_) – whether to infer storage types

autodetect_settings(_infer_storage_types =False_)
    

Detect appropriate settings for this dataset using Dataiku detection engine

Parameters:
    

**infer_storage_types** (_bool_) – whether to infer storage types

Returns:
    

new suggested settings that you can `DSSDatasetSettings.save()`

Return type:
    

`DSSDatasetSettings` or a subclass

get_as_core_dataset()
    

Get the `dataiku.Dataset` object corresponding to this dataset

Return type:
    

`dataiku.Dataset`

new_code_recipe(_type_ , _code =None_, _recipe_name =None_)
    

Start the creation of a new code recipe taking this dataset as input.

Parameters:
    

  * **type** (_str_) – type of the recipe (‘python’, ‘r’, ‘pyspark’, ‘sparkr’, ‘sql’, ‘sparksql’, ‘hive’, …).

  * **code** (_str_) – the code of the recipe.

  * **recipe_name** (_str_) – (optional) base name for the new recipe.



Returns:
    

a handle to the new recipe’s creator object.

Return type:
    

Union[[`dataikuapi.dss.recipe.CodeRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.CodeRecipeCreator> "dataikuapi.dss.recipe.CodeRecipeCreator"), [`dataikuapi.dss.recipe.PythonRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.PythonRecipeCreator> "dataikuapi.dss.recipe.PythonRecipeCreator")]

new_recipe(_type_ , _recipe_name =None_)
    

Start the creation of a new recipe taking this dataset as input. For more details, please see [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe")

Parameters:
    

  * **type** (_str_) – type of the recipe (‘python’, ‘r’, ‘pyspark’, ‘sparkr’, ‘sql’, ‘sparksql’, ‘hive’, …).

  * **recipe_name** (_str_) – (optional) base name for the new recipe.




get_data_quality_rules()
    

Get a handle to interact with the data quality rules of the dataset.

Returns:
    

A handle to the data quality rules of the dataset.

Return type:
    

[`dataikuapi.dss.data_quality.DSSDataQualityRuleSet`](<data-quality.html#dataikuapi.dss.data_quality.DSSDataQualityRuleSet> "dataikuapi.dss.data_quality.DSSDataQualityRuleSet")

get_column_lineage(_column_ , _max_dataset_count =None_)
    

Get the full lineage (auto-computed and manual) information of a column in this dataset. Column relations with datasets from both local and foreign projects will be included in the result.

Parameters:
    

  * **column** (_str_) – name of the column to retrieve the lineage on.

  * **max_dataset_count** (_integer_) – (optional) the maximum number of datasets to query for. If none, then the max hard limit is used.



Returns:
    

the full column lineage (auto-computed and manual) as a list of relations.

Return type:
    

list of dict

### Listing datasets

_class _dataikuapi.dss.dataset.DSSDatasetListItem(_client_ , _data_)
    

An item in a list of datasets.

Caution

Do not instantiate this class, use [`dataikuapi.dss.project.DSSProject.list_datasets()`](<projects.html#dataikuapi.dss.project.DSSProject.list_datasets> "dataikuapi.dss.project.DSSProject.list_datasets")

to_dataset()
    

Gets a handle on the corresponding dataset.

Returns:
    

a handle on a dataset

Return type:
    

`DSSDataset`

_property _name
    

Get the name of the dataset.

Return type:
    

string

_property _id
    

Get the identifier of the dataset.

Return type:
    

string

_property _type
    

Get the type of the dataset.

Return type:
    

string

_property _schema
    

Get the dataset schema as a dict.

Returns:
    

a dict object of the schema, with the list of columns. See `DSSDataset.get_schema()`

Return type:
    

dict

_property _connection
    

Get the name of the connection on which this dataset is attached, or None if there is no connection for this dataset.

Return type:
    

string

get_column(_column_)
    

Get a given column in the dataset schema by its name.

Parameters:
    

**column** (_str_) – name of the column to find

Returns:
    

the column settings or None if column does not exist

Return type:
    

dict

### Settings of datasets

_class _dataikuapi.dss.dataset.DSSDatasetSettings(_dataset_ , _settings_)
    

Base settings class for a DSS dataset.

Caution

Do not instantiate this class directly, use `DSSDataset.get_settings()`

Use `save()` to save your changes

get_raw()
    

Get the raw dataset settings as a dict.

Return type:
    

dict

get_raw_params()
    

Get the type-specific params, as a raw dict.

Return type:
    

dict

_property _type
    

Returns the settings type as a string.

Return type:
    

string

_property _schema_columns
    

Get the schema columns settings.

Returns:
    

a list of dicts with column settings.

Return type:
    

list[dict]

remove_partitioning()
    

Reset partitioning settings to those of a non-partitioned dataset.

add_discrete_partitioning_dimension(_dim_name_)
    

Add a discrete partitioning dimension to settings.

Parameters:
    

**dim_name** (_string_) – name of the partition to add.

add_time_partitioning_dimension(_dim_name_ , _period ='DAY'_)
    

Add a time partitioning dimension to settings.

Parameters:
    

  * **dim_name** (_string_) – name of the partition to add.

  * **period** (_string_) – (optional) time granularity of the created partition. Can be YEAR, MONTH, DAY, HOUR.




add_raw_schema_column(_column_)
    

Add a column to the schema settings.

Parameters:
    

**column** (_dict_) – column settings to add.

_property _is_feature_group
    

Indicates whether the Dataset is defined as a Feature Group, available in the Feature Store.

Return type:
    

bool

set_feature_group(_status_)
    

(Un)sets the dataset as a Feature Group, available in the Feature Store. Changes of this property will be applied when calling `save()` and require the “Manage Feature Store” permission.

Parameters:
    

**status** (_bool_) – whether the dataset should be defined as a feature group

_property _data_steward
    

Get or set the Data Steward of the dataset.

  * **Getter** : Returns the identifier (login name) of the Data Steward.




If not explicitly set, it falls back to the dataset creator’s login or returns None if unavailable.

  * **Setter** : Assigns the Data Steward of the dataset (user login name)




Returns:
    

the identifier of the Data Steward user (i.e. login name) or None

Return type:
    

string or None

save()
    

Save settings.

_class _dataikuapi.dss.dataset.SQLDatasetSettings(_dataset_ , _settings_)
    

Settings for a SQL dataset. This class inherits from `DSSDatasetSettings`.

Caution

Do not instantiate this class directly, use `DSSDataset.get_settings()`

Use `save()` to save your changes

set_table(_connection_ , _schema_ , _table_ , _catalog =None_)
    

Sets this SQL dataset in ‘table’ mode, targeting a particular table of a connection Leave catalog to None to target the default database associated with the connection

_class _dataikuapi.dss.dataset.FSLikeDatasetSettings(_dataset_ , _settings_)
    

Settings for a files-based dataset. This class inherits from `DSSDatasetSettings`.

Caution

Do not instantiate this class directly, use `DSSDataset.get_settings()`

Use `save()` to save your changes

set_connection_and_path(_connection_ , _path_)
    

Set connection and path parameters.

Parameters:
    

  * **connection** (_string_) – connection to use.

  * **path** (_string_) – path to use.




get_raw_format_params()
    

Get the raw format parameters as a dict.

Return type:
    

dict

set_format(_format_type_ , _format_params =None_)
    

Set format parameters.

Parameters:
    

  * **format_type** (_string_) – format type to use.

  * **format_params** (_dict_) – dict of parameters to assign to the formatParams settings section.




set_csv_format(_separator =','_, _style ='excel'_, _skip_rows_before =0_, _header_row =True_, _skip_rows_after =0_)
    

Set format parameters for a csv-based dataset.

Parameters:
    

  * **separator** (_string_) – (optional) separator to use, default is ‘,’”.

  * **style** (_string_) – (optional) style to use, default is ‘excel’.

  * **skip_rows_before** (_int_) – (optional) number of rows to skip before header, default is 0.

  * **header_row** (_bool_) – (optional) wheter or not the header row is parsed, default is true.

  * **skip_rows_after** (_int_) – (optional) number of rows to skip before header, default is 0.




set_partitioning_file_pattern(_pattern_)
    

Set the dataset partitionning file pattern.

Parameters:
    

**pattern** (_str_) – pattern to set.

### Dataset Information

_class _dataikuapi.dss.dataset.DSSDatasetInfo(_dataset_ , _info_)
    

Info class for a DSS dataset (Read-Only).

Caution

Do not instantiate this class directly, use `DSSDataset.get_info()`

get_raw()
    

Get the raw dataset full information as a dict

Returns:
    

the raw dataset full information

Return type:
    

dict

_property _last_build_start_time
    

The last build start time of the dataset as a `datetime.datetime` or None if there is no last build information.

Returns:
    

the last build start time

Return type:
    

`datetime.datetime` or None

_property _last_build_end_time
    

The last build end time of the dataset as a `datetime.datetime` or None if there is no last build information.

Returns:
    

the last build end time

Return type:
    

`datetime.datetime` or None

_property _is_last_build_successful
    

Get whether the last build of the dataset is successful.

Returns:
    

True if the last build is successful

Return type:
    

bool

### Creation of managed datasets

_class _dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper(_project_ , _dataset_name_)
    

Provide an helper to create partitioned dataset
    
    
    import dataiku
    
    client = dataiku.api_client()
    project_key = dataiku.default_project_key()
    project = client.get_project(project_key)
    
    #create the dataset
    builder = project.new_managed_dataset("py_generated")
    builder.with_store_into("filesystem_folders")
    dataset = builder.create(overwrite=True)
    
    #setup format & schema  settings
    ds_settings = ds.get_settings()
    ds_settings.set_csv_format()
    ds_settings.add_raw_schema_column({'name':'id', 'type':'int'})
    ds_settings.add_raw_schema_column({'name':'name', 'type':'string'})
    ds_settings.save()
    
    #put some data
    data = ["foo", "bar"]
    with ds.get_as_core_dataset().get_writer() as writer:
        for idx, val in enumerate(data):
            writer.write_row_array((idx, val))
    

Caution

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_managed_dataset()`](<projects.html#dataikuapi.dss.project.DSSProject.new_managed_dataset> "dataikuapi.dss.project.DSSProject.new_managed_dataset")

get_creation_settings()
    

Get the dataset creation settings as a dict.

Return type:
    

dict

with_store_into(_connection_ , _type_option_id =None_, _format_option_id =None_)
    

Sets the connection into which to store the new managed dataset

Parameters:
    

  * **connection** (_str_) – Name of the connection to store into

  * **type_option_id** (_str_) – If the connection accepts several types of datasets, the type

  * **format_option_id** (_str_) – Optional identifier of a file format option



Returns:
    

self

with_copy_partitioning_from(_dataset_ref_ , _object_type ='DATASET'_)
    

Sets the new managed dataset to use the same partitioning as an existing dataset

Parameters:
    

  * **dataset_ref** (_str_) – Name of the dataset to copy partitioning from

  * **object_type** (_str_) – Type of the object to copy partitioning from, values can be DATASET or FOLDER



Returns:
    

self

create(_overwrite =False_)
    

Executes the creation of the managed dataset according to the selected options

Parameters:
    

**overwrite** (_bool_ _,__optional_) – If the dataset being created already exists, delete it first (removing data), defaults to False

Returns:
    

the newly created dataset

Return type:
    

`DSSDataset`

already_exists()
    

Check if dataset already exists.

Returns:
    

whether this managed dataset already exists

Return type:
    

bool

---

## [api-reference/python/discussions]

# Discussions

For usage information and examples, see [Discussions](<../../concepts-and-examples/discussions.html>)

_class _dataikuapi.dss.discussion.DSSObjectDiscussions(_client_ , _project_key_ , _object_type_ , _object_id_)
    

A handle to manage discussions on a DSS object.

Important

Do not create this class directly, instead use [`dataikuapi.DSSClient.get_object_discussions()`](<client.html#dataikuapi.DSSClient.get_object_discussions> "dataikuapi.DSSClient.get_object_discussions") on any commentable DSS object.

list_discussions()
    

Gets the list of discussions on the object.

Returns:
    

list of discussions on the object

Return type:
    

list of `dataikuapi.dss.discussion.DSSDiscussion`

create_discussion(_topic_ , _message_)
    

Creates a new discussion with one message.

Parameters:
    

  * **topic** (_str_) – the discussion topic

  * **message** (_str_) – the markdown formatted first message



Returns:
    

the newly created discussion

Return type:
    

`dataikuapi.dss.discussion.DSSDiscussion`

get_discussion(_discussion_id_)
    

Gets a specific discussion.

Parameters:
    

**discussion_id** (_str_) – the discussion ID

Returns:
    

the discussion

Return type:
    

`dataikuapi.dss.discussion.DSSDiscussion`

_class _dataikuapi.dss.discussion.DSSDiscussion(_client_ , _project_key_ , _object_type_ , _object_id_ , _discussion_id_ , _discussion_data_ , _discussion_data_has_replies_)
    

A handle to interact with a discussion.

Important

Do not call directly, use `dataikuapi.dss.discussion.DSSObjectDiscussions.get_discussion()`, `dataikuapi.dss.discussion.DSSObjectDiscussions.create_discussion()` or `dataikuapi.dss.discussion.DSSObjectDiscussions.list_discussions()`.

get_metadata()
    

Gets the discussion metadata.

Returns:
    

the discussion metadata

Return type:
    

dict

set_metadata(_discussion_metadata_)
    

Updates the discussion metadata.

Parameters:
    

**discussion_metadata** (_dict_) – the discussion metadata

get_replies()
    

Gets the list of replies in this discussion.

Returns:
    

a list of replies

Return type:
    

list of `dataikuapi.dss.discussion.DSSDiscussionReply`

add_reply(_text_)
    

Adds a reply to a discussion.

Parameters:
    

**text** (_str_) – the markdown formatted text to reply

_class _dataikuapi.dss.discussion.DSSDiscussionReply(_reply_data_)
    

A read-only handle to access a discussion reply.

Important

Do not create this class directly, use `dataikuapi.dss.discussion.DSSDiscussion.get_replies()`

get_raw_data()
    

Gets the reply raw data.

Returns:
    

the reply data

Return type:
    

dict

get_text()
    

Gets the reply text.

Returns:
    

the reply text

Return type:
    

str

get_author()
    

Gets the reply author.

Returns:
    

the author ID

Return type:
    

str

get_timestamp()
    

Gets the reply timestamp.

Returns:
    

the reply timestamp

Return type:
    

long

get_edited_timestamp()
    

Gets the last edition timestamp.

Returns:
    

the last edition timestamp

Return type:
    

long

---

## [api-reference/python/enterprise-asset-library]

# Enterprise Asset Library

_class _dataikuapi.dss.enterprise_asset_library.DSSEnterpriseAssetLibrary(_client_)
    

Handle to interact with the Enterprise Asset Library on the DSS instance.

Important

Do not create this class directly, use [`dataikuapi.DSSClient.get_enterprise_asset_library()`](<client.html#dataikuapi.DSSClient.get_enterprise_asset_library> "dataikuapi.DSSClient.get_enterprise_asset_library")

list_collections()
    

Lists the collections you have read access to in the Enterprise Asset Library as dict. Each dict contains at least a field “id” indicating the identifier of this collection and “name”

Returns:
    

a list of dict

Return type:
    

list[dict]

list_prompts(_restrict_collections =None_)
    

Lists the prompts in the collections you have read access to

Parameters:
    

**restrict_collections** (_(__optional_ _)__list_ _[__string_ _]_) – collection ids you want to get the prompts from

Returns:
    

the list of prompts in the collections you have access to

Return type:
    

list[dict]

get_collection(_collection_id_)
    

Get a handle to interact with a specific Enterprise Asset Collection

Parameters:
    

**collection_id** (_str_) – the id of the Enterprise Asset Collection to fetch

Return type:
    

`dataikuapi.dss.enterprise_asset_library.DSSEnterpriseAssetCollection`

---

## [api-reference/python/experiment-tracking]

# Experiment Tracking

For usage information and examples, see [Experiment Tracking](<../../concepts-and-examples/experiment-tracking.html>).

Experiment Tracking in DSS uses the [MLflow Tracking](<https://www.mlflow.org/docs/2.17.2/tracking.html>) API.

This section focuses on Dataiku-specific Extensions to the MLflow API

[`dataikuapi.dss.project.DSSProject.get_mlflow_extension`](<projects.html#dataikuapi.dss.project.DSSProject.get_mlflow_extension> "dataikuapi.dss.project.DSSProject.get_mlflow_extension")() | Get a handle to interact with the extension of MLflow provided by DSS  
---|---  
  
_class _dataikuapi.dss.mlflow.DSSMLflowExtension(_client_ , _project_key_)
    

A handle to interact with specific endpoints of the DSS MLflow integration.

Do not create this directly, use [`dataikuapi.dss.project.DSSProject.get_mlflow_extension()`](<projects.html#dataikuapi.dss.project.DSSProject.get_mlflow_extension> "dataikuapi.dss.project.DSSProject.get_mlflow_extension")

list_models(_run_id_)
    

Returns the list of models of given run

Parameters:
    

**run_id** (_str_) – run_id for which to return a list of models

list_experiments(_view_type ='ACTIVE_ONLY'_, _max_results =1000_)
    

Returns the list of experiments in the DSS project for which MLflow integration is setup

Parameters:
    

  * **view_type** (_str_) – ACTIVE_ONLY, DELETED_ONLY or ALL

  * **max_results** (_int_) – max results count



Return type:
    

dict

rename_experiment(_experiment_id_ , _new_name_)
    

Renames an experiment

Parameters:
    

  * **experiment_id** (_str_) – experiment id

  * **new_name** (_str_) – new name




restore_experiment(_experiment_id_)
    

Restores a deleted experiment

Parameters:
    

**experiment_id** (_str_) – experiment id

restore_run(_run_id_)
    

Restores a deleted run

Parameters:
    

**run_id** (_str_) – run id

garbage_collect()
    

Permanently deletes the experiments and runs marked as “Deleted”

create_experiment_tracking_dataset(_dataset_name_ , _experiment_ids =[]_, _view_type ='ACTIVE_ONLY'_, _filter_expr =''_, _order_by =[]_, _format ='LONG'_)
    

Creates a virtual dataset exposing experiment tracking data.

Parameters:
    

  * **dataset_name** (_str_) – name of the dataset

  * **experiment_ids** (_list_ _(__str_ _)_) – list of ids of experiments to filter on. No filtering if empty

  * **view_type** (_str_) – one of ACTIVE_ONLY, DELETED_ONLY and ALL. Default is ACTIVE_ONLY

  * **filter_expr** (_str_) – MLflow search expression

  * **order_by** (_list_ _(__str_ _)_) – list of order by clauses. Default is ordered by start_time, then runId

  * **format** (_str_) – LONG or JSON. Default is LONG




clean_experiment_tracking_db()
    

Cleans the experiments, runs, params, metrics, tags, etc. for this project

This call requires an API key with admin rights

set_run_inference_info(_run_id_ , _prediction_type_ , _classes =None_, _code_env_name =None_, _target =None_)
    

Sets the type of the model, and optionally other information useful to deploy or evaluate it.

prediction_type must be one of:

  * REGRESSION

  * BINARY_CLASSIFICATION

  * MULTICLASS

  * OTHER




Classes must be specified if and only if the model is a BINARY_CLASSIFICATION or MULTICLASS model.

This information is leveraged to filter saved models on their prediction type and prefill the classes when deploying (using the GUI or `deploy_run_model()`) an MLflow model as a version of a DSS Saved Model.

Parameters:
    

  * **prediction_type** (_str_) – prediction type (see doc)

  * **run_id** (_str_) – run_id for which to set the classes

  * **classes** (_list_) – ordered list of classes (not for all prediction types, see doc). Every class will be converted by calling str(). The classes must be specified in the same order as learned by the model. Some flavors such as scikit-learn may allow you to build this list from the model itself.

  * **code_env_name** (_str_) – name of an adequate DSS python code environment

  * **target** (_str_) – name of the target




deploy_run_model(_run_id_ , _sm_id_ , _version_id =None_, _use_inference_info =True_, _code_env_name =None_, _evaluation_dataset =None_, _target_column_name =None_, _class_labels =None_, _model_sub_folder =None_, _model_name =None_, _selection =None_, _activate =True_, _binary_classification_threshold =0.5_, _use_optimal_threshold =True_, _skip_expensive_reports =False_)
    

Deploys a model from an experiment run, with lineage.

Simple usage:
    
    
    mlflow_ext.set_run_inference_info(run_id, "BINARY_CLASSIFICATION", list_of_classes, code_env_name, target_column_name)
    sm_id = project.create_mlflow_pyfunc_model("model_name", "BINARY_CLASSIFICATION").id
    mlflow_extension.deploy_run_model(run_id, sm_id, evaluation_dataset)
    

If the optional evaluation_dataset is not set, the model will be deployed but not evaluated: this makes target_column_name optional as well in `set_run_inference_info()`

Parameters:
    

  * **run_id** (_str_) – The id of the run to deploy

  * **sm_id** (_str_) – The id of the saved model to deploy the run to

  * **version_id** (_str_) – [optional] Unique identifier of a Saved Model Version. If it already exists, existing version is overwritten. Whitespaces or dashes are not allowed. If not set, a timestamp will be used as version_id.

  * **use_inference_info** (_bool_) – [optional] default to True. if set, uses the `set_run_inference_info()` previously done on the run to retrieve the prediction type of the model, its code environment, classes and target.

  * **evaluation_dataset** (_str_) – [optional] The evaluation dataset, if the deployment of the models can imply an evaluation.

  * **target_column_name** (_str_) – [optional] The target column of the evaluation dataset. Can be set by `set_run_inference_info()`.

  * **class_labels** (_list_ _(__str_ _)_) – [optional] The class labels of the target. Can be set by `set_run_inference_info()`.

  * **code_env_name** (_str_) – [optional] The code environment to be used. Must contain a supported version of the mlflow package and the ML libs used to train the model. Can be set by `set_run_inference_info()`.

  * **model_sub_folder** (_str_) – 

Deprecated since version 14.5.0: Use model_name instead.

  * **model_name** (_str_) – [optional] The name of the model. Optional if it is unique. Existing values can be retrieved with project.get_mlflow_extension().list_models(run_id)

  * **selection** (`DSSDatasetSelectionBuilder` optional sampling parameter for the evaluation or dict) – 

[optional] will default to HEAD_SEQUENTIAL with a maxRecords of 10_000. e.g.

    * Example 1: `DSSDatasetSelectionBuilder().with_head_sampling(100)`

    * Example 2: `{"samplingMethod": "HEAD_SEQUENTIAL", "maxRecords": 100}`

  * **activate** (_bool_) – [optional] True by default. Activate or not the version after deployment

  * **binary_classification_threshold** (_float_) – [optional] Threshold (or cut-off) value to override if the model is a binary classification

  * **use_optimal_threshold** (_bool_) – [optional] Use or not the optimal threshold for the saved model metric computed at evaluation

  * **skip_expensive_reports** (_bool_) – [optional] Don’t compute expensive report screens (e.g. feature importance).



Returns:
    

a handler in order to interact with the new MLFlow model version

Return type:
    

[`dataikuapi.dss.savedmodel.ExternalModelVersionHandler`](<ml.html#dataikuapi.dss.savedmodel.ExternalModelVersionHandler> "dataikuapi.dss.savedmodel.ExternalModelVersionHandler")

import_analyses_models_into_experiment(_model_ids_ , _experiment_id_)
    

Import models from a visual ML analysis into an existing experiment. import dataiku

Usage example
    
    
    # Retrieve all the trained model ids of the first task of the first analysis of a project
    project = client.get_project("YOUR_PROJECT_ID")
    first_analysis_id = project.list_analyses()[0]['analysisId']
    first_analysis = project.get_analysis(first_analysis_id)
    first_task_id = first_analysis.list_ml_tasks()['mlTasks'][0]['mlTaskId']
    first_task = first_analysis.get_ml_task(first_task_id)
    full_model_ids = first_task.get_trained_models_ids()
    # Create a new experiment
    with project.setup_mlflow(project.create_managed_folder("mlflow")) as mlflow:
        experiment_id = mlflow.create_experiment("Sample export of DSS visual analysis models")
    # Export the retrieved model ids to the created experiment
    project.get_mlflow_extension().import_analyses_models_into_experiment(full_model_ids, experiment_id)
    

Parameters:
    

  * **model_ids** (_list_ _of_ _str_) – IDs of models from a Visual Analysis.

  * **experiment_id** (_str_) – ID of the experiment into which the visual analysis models will be imported.

---

## [api-reference/python/feature-store]

# Feature Store

For usage information and examples, see [Feature Store](<../../concepts-and-examples/feature-store.html>)

_class _dataikuapi.dss.feature_store.DSSFeatureStore(_client_)
    

A handle on the Feature Store.

Important

Do not create this class directly, use [`dataikuapi.DSSClient.get_feature_store()`](<client.html#dataikuapi.DSSClient.get_feature_store> "dataikuapi.DSSClient.get_feature_store")

list_feature_groups()
    

List the feature groups on which the user has at least read permissions.

Returns:
    

the list of feature groups, each one as a `dataikuapi.dss.feature_store.DSSFeatureGroupListItem`

Return type:
    

list of `dataikuapi.dss.feature_store.DSSFeatureGroupListItem`

_class _dataikuapi.dss.feature_store.DSSFeatureGroupListItem(_client_ , _project_key_ , _name_)
    

An item in a list of feature groups.

Important

Do not instantiate this class, use :meth:’dataikuapi.dss.feature_store.DSSFeatureStore.list_feature_groups’

_property _id
    

Get the identifier of the feature group.

Return type:
    

string

get_as_dataset()
    

Get the feature group as a dataset.

Returns:
    

a handle on the dataset

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

---

## [api-reference/python/fleetmanager]

# Fleet Manager

For usage information and examples, see [Fleet Manager](<../../concepts-and-examples/fleetmanager/index.html>).

## The main FMClient class

_class _dataikuapi.fmclient.FMClient(_host_ , _api_key_id_ , _api_key_secret_ , _tenant_id ='main'_, _extra_headers =None_, _no_check_certificate =False_, _client_certificate =None_, _** kwargs_)
    

get_tenant_id()
    

get_cloud_credentials()
    

Get the cloud credentials :return: cloud credentials :rtype: `dataikuapi.fm.tenant.FMCloudCredentials`

get_sso_settings()
    

Get the Single Sign-On (SSO) settings

Returns:
    

SSO settings

Return type:
    

`dataikuapi.iam.settings.SSOSettings`

get_ldap_settings()
    

Get the LDAP settings

Returns:
    

LDAP settings

Return type:
    

`dataikuapi.iam.settings.LDAPSettings`

get_azure_ad_settings()
    

Get the Azure Active Directory (aka Microsoft Entra ID) settings

Returns:
    

Azure AD settings

Return type:
    

`dataikuapi.iam.settings.AzureADSettings`

get_cloud_tags()
    

Get the tenant’s cloud tags

Returns:
    

tenant’s cloud tags

Return type:
    

`dataikuapi.fm.tenant.FMCloudTags`

list_cloud_accounts()
    

List all cloud accounts

Returns:
    

list of cloud accounts

Return type:
    

list of `dataikuapi.fm.cloudaccounts.FMCloudAccount`

get_cloud_account(_cloud_account_id_)
    

Get a cloud account by its id

Parameters:
    

**cloud_account_id** (_str_) – the id of the cloud account to retrieve

Returns:
    

the requested cloud account

Return type:
    

`dataikuapi.fm.cloudaccounts.FMCloudAccount`

list_virtual_networks()
    

List all virtual networks

Returns:
    

list of virtual networks

Return type:
    

list of `dataikuapi.fm.virtualnetworks.FMVirtualNetwork`

get_virtual_network(_virtual_network_id_)
    

Get a virtual network by its id

Parameters:
    

**virtual_network_id** (_str_) – the id of the network to retrieve

Returns:
    

the requested virtual network

Return type:
    

`dataikuapi.fm.virtualnetworks.FMVirtualNetwork`

list_load_balancers()
    

List all load balancers

Returns:
    

list of load balancers

Return type:
    

list of `dataikuapi.fm.loadbalancers.FMLoadBalancer`

get_load_balancer(_load_balancer_id_)
    

Get a load balancer by its id

Parameters:
    

**load_balancer_id** (_str_) – the id of the load balancer to retrieve

Returns:
    

the requested load balancer

Return type:
    

`dataikuapi.fm.loadbalancers.FMLoadBalancer`

list_instance_templates()
    

List all instance settings templates

Returns:
    

list of instance settings template

Return type:
    

list of `dataikuapi.fm.tenant.FMInstanceSettingsTemplate`

get_instance_template(_template_id_)
    

Get an instance setting template template by its id

Parameters:
    

**template_id** (_str_) – the id of the template to retrieve

Returns:
    

the requested instance settings template

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplate`

list_instances()
    

List all DSS instances

Returns:
    

list of instances

Return type:
    

list of `dataikuapi.fm.instances.FMInstance`

get_instance(_instance_id_)
    

Get a DSS instance by its id

Parameters:
    

**instance_id** (_str_) – the id of the instance to retrieve

Returns:
    

the requested instance if any

Return type:
    

`dataikuapi.fm.instances.FMInstance`

list_instance_images()
    

List all available images to create new instances

Returns:
    

list of images, as a pair of id and label

_class _dataikuapi.fmclient.FMClientAWS(_host_ , _api_key_id_ , _api_key_secret_ , _tenant_id ='main'_, _extra_headers =None_, _no_check_certificate =False_, _** kwargs_)
    

new_cloud_account_creator(_label_)
    

Instantiate a new cloud account creator

Parameters:
    

**label** (_str_) – The label of the cloud account

Return type:
    

`dataikuapi.fm.cloudaccounts.FMAWSCloudAccountCreator`

new_virtual_network_creator(_label_)
    

Instantiate a new virtual network creator

Parameters:
    

**label** (_str_) – The label of the network

Return type:
    

`dataikuapi.fm.virtualnetworks.FMAWSVirtualNetworkCreator`

new_load_balancer_creator(_name_ , _virtual_network_id_)
    

Instantiate a new load balancer creator

Parameters:
    

  * **name** (_str_) – The name of the load balancer

  * **virtual_network_id** (_str_) – The id of the virtual network



Return type:
    

`dataikuapi.fm.loadbalancers.FMAWSLoadBalancerCreator`

new_instance_template_creator(_label_)
    

Instantiate a new instance template creator

Parameters:
    

**label** (_str_) – The label of the instance

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMAWSInstanceSettingsTemplateCreator`

new_instance_creator(_label_ , _instance_settings_template_id_ , _virtual_network_id_ , _image_id_)
    

Instantiate a new instance creator

Parameters:
    

  * **label** (_str_) – The label of the instance

  * **instance_settings_template** (_str_) – The instance settings template id this instance should be based on

  * **virtual_network** (_str_) – The virtual network where the instance should be spawned

  * **image_id** (_str_) – The ID of the DSS runtime image (ex: dss-9.0.3-default)



Return type:
    

`dataikuapi.fm.instances.FMAWSInstanceCreator`

_class _dataikuapi.fmclient.FMClientAzure(_host_ , _api_key_id_ , _api_key_secret_ , _tenant_id ='main'_, _extra_headers =None_, _no_check_certificate =False_, _** kwargs_)
    

new_cloud_account_creator(_label_)
    

Instantiate a new cloud account creator

Parameters:
    

**label** (_str_) – The label of the cloud account

Return type:
    

`dataikuapi.fm.cloudaccounts.FMAzureCloudAccountCreator`

new_virtual_network_creator(_label_)
    

Instantiate a new virtual network creator

Parameters:
    

**label** (_str_) – The label of the network

Return type:
    

`dataikuapi.fm.virtualnetworks.FMAzureVirtualNetworkCreator`

new_load_balancer_creator(_name_ , _virtual_network_id_)
    

Instantiate a new Load balancer creator

Parameters:
    

  * **name** (_str_) – The name of the load balancer

  * **virtual_network_id** (_str_) – The id of the virtual network



Return type:
    

`dataikuapi.fm.loadbalancers.FMAzureLoadBalancerCreator`

new_instance_template_creator(_label_)
    

Instantiate a new instance template creator

Parameters:
    

**label** (_str_) – The label of the instance

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMAzureInstanceSettingsTemplateCreator`

new_instance_creator(_label_ , _instance_settings_template_id_ , _virtual_network_id_ , _image_id_)
    

Instantiate a new instance creator

Parameters:
    

  * **label** (_str_) – The label of the instance

  * **instance_settings_template** (_str_) – The instance settings template id this instance should be based on

  * **virtual_network** (_str_) – The virtual network where the instance should be spawned

  * **image_id** (_str_) – The ID of the DSS runtime image (ex: dss-9.0.3-default)



Return type:
    

`dataikuapi.fm.instances.FMAzureInstanceCreator`

_class _dataikuapi.fmclient.FMClientGCP(_host_ , _api_key_id_ , _api_key_secret_ , _tenant_id ='main'_, _extra_headers =None_, _no_check_certificate =False_, _** kwargs_)
    

new_cloud_account_creator(_label_)
    

Instantiate a new cloud account creator

Parameters:
    

**label** (_str_) – The label of the cloud account

Return type:
    

`dataikuapi.fm.cloudaccounts.FMGCPCloudAccountCreator`

new_virtual_network_creator(_label_)
    

Instantiate a new virtual network creator

Parameters:
    

**label** (_str_) – The label of the network

Return type:
    

`dataikuapi.fm.virtualnetworks.FMGCPVirtualNetworkCreator`

new_instance_template_creator(_label_)
    

Instantiate a new instance template creator

Parameters:
    

**label** (_str_) – The label of the instance

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMGCPInstanceSettingsTemplateCreator`

new_instance_creator(_label_ , _instance_settings_template_id_ , _virtual_network_id_ , _image_id_)
    

Instantiate a new instance creator

Parameters:
    

  * **label** (_str_) – The label of the instance

  * **instance_settings_template** (_str_) – The instance settings template id this instance should be based on

  * **virtual_network** (_str_) – The virtual network where the instance should be spawned

  * **image_id** (_str_) – The ID of the DSS runtime image (ex: dss-9.0.3-default)



Return type:
    

`dataikuapi.fm.instances.FMGCPInstanceCreator`

## Fleet Manager Accounts

_class _dataikuapi.fm.cloudaccounts.FMCloudAccount(_client_ , _account_data_)
    

delete()
    

Delete this cloud account.

Returns:
    

the Future object representing the deletion process

Return type:
    

`dataikuapi.fm.future.FMFuture`

save()
    

Save this cloud account.

_class _dataikuapi.fm.cloudaccounts.FMCloudAccountCreator(_client_ , _label_)
    

with_description(_description_)
    

Set the description of this cloud account

Parameters:
    

**description** (_str_) – the description of the cloud account

Return type:
    

`dataikuapi.fm.cloudaccounts.FMCloudAccountCreator`

_class _dataikuapi.fm.cloudaccounts.FMAWSCloudAccount(_client_ , _account_data_)
    

set_same_as_fm()
    

Use the same authentication as Fleet Manager

set_iam_role(_role_arn_)
    

Use an IAM Role

Parameters:
    

**role_arn** (_str_) – ARN of the IAM Role

set_keypair(_access_key_id_ , _secret_access_key_)
    

Use an AWS Access Key

Parameters:
    

  * **access_key_id** (_str_) – AWS Access Key ID

  * **secret_access_key** (_str_) – AWS Secret Access Key




_class _dataikuapi.fm.cloudaccounts.FMAWSCloudAccountCreator(_client_ , _label_)
    

same_as_fm()
    

Use the same authentication as Fleet Manager

with_iam_role(_role_arn_)
    

Use an IAM Role

Parameters:
    

**role_arn** (_str_) – ARN of the IAM Role

with_keypair(_access_key_id_ , _secret_access_key_)
    

Use an AWS Access Key

Parameters:
    

  * **access_key_id** (_str_) – AWS Access Key ID

  * **secret_access_key** (_str_) – AWS Secret Access Key




create()
    

Create a new cloud account

Returns:
    

a newly created cloud account

Return type:
    

`dataikuapi.fm.cloudaccounts.FMAWSCloudAccount`

_class _dataikuapi.fm.cloudaccounts.FMAzureCloudAccount(_client_ , _account_data_)
    

set_same_as_fm(_tenant_id_ , _image_resource_group_)
    

Use the same authentication as Fleet Manager

Parameters:
    

  * **tenant_id** (_str_) – Azure Tenant Id

  * **image_resource_group** (_str_) – Azure image cached resource group




set_secret(_subscription_ , _tenant_id_ , _environment_ , _client_id_ , _image_resource_group_ , _secret_)
    

Use a Secret based authentication

Parameters:
    

  * **subscription** (_str_) – Azure Subscription

  * **tenant_id** (_str_) – Azure Tenant Id

  * **environment** (_str_) – Azure Environment

  * **client_id** (_str_) – Azure Client Id

  * **image_resource_group** (_str_) – Azure image cached resource group

  * **secret** (_str_) – Azure Secret




set_certificate(_subscription_ , _tenant_id_ , _environment_ , _client_id_ , _image_resource_group_ , _certificate_path_ , _certificate_password_)
    

Use a Secret based authentication

Parameters:
    

  * **subscription** (_str_) – Azure Subscription

  * **tenant_id** (_str_) – Azure Tenant Id

  * **environment** (_str_) – Azure Environment

  * **client_id** (_str_) – Azure Client Id

  * **image_resource_group** (_str_) – Azure image cached resource group

  * **certificate_path** (_str_) – Azure certificate path

  * **certificate_password** (_str_) – Azure certificate password




set_managed_identity(_tenant_id_ , _environment_ , _managed_identity_ , _image_resource_group_)
    

Use a Managed Identity based authentication

Parameters:
    

  * **tenant_id** (_str_) – Azure Tenant identifier

  * **environment** (_str_) – Azure Environment

  * **image_resource_group** (_str_) – Azure image cached resource group

  * **managed_identity** (_str_) – Azure Managed Identity




_class _dataikuapi.fm.cloudaccounts.FMAzureCloudAccountCreator(_client_ , _label_)
    

same_as_fm(_subscription_ , _tenant_id_ , _image_resource_group_)
    

Use the same authentication as Fleet Manager

Parameters:
    

  * **subscription** (_str_) – Azure Subscription

  * **tenant_id** (_str_) – Azure Tenant Id

  * **image_resource_group** (_str_) – Azure image cached resource group




with_secret(_subscription_ , _tenant_id_ , _environment_ , _image_resource_group_ , _client_id_ , _secret_)
    

Use a Secret based authentication

Parameters:
    

  * **subscription** (_str_) – Azure Subscription

  * **tenant_id** (_str_) – Azure Tenant Id

  * **environment** (_str_) – Azure Environment

  * **client_id** (_str_) – Azure Client Id

  * **image_resource_group** (_str_) – Azure image cached resource group

  * **secret** (_str_) – Azure Secret




with_certificate(_subscription_ , _tenant_id_ , _environment_ , _client_id_ , _image_resource_group_ , _certificate_path_ , _certificate_password_)
    

Use a Secret based authentication

Parameters:
    

  * **subscription** (_str_) – Azure Subscription

  * **tenant_id** (_str_) – Azure Tenant Id

  * **environment** (_str_) – Azure Environment

  * **client_id** (_str_) – Azure Client Id

  * **image_resource_group** (_str_) – Azure image cached resource group

  * **certificate_path** (_str_) – Azure certificate path

  * **certificate_password** (_str_) – Azure certificate password




with_managed_identity(_tenant_id_ , _environment_ , _image_resource_group_ , _managed_identity_)
    

Use a Managed Identity based authentication

Parameters:
    

  * **tenant_id** (_str_) – Azure Tenant identifier

  * **environment** (_str_) – Azure Environment

  * **image_resource_group** (_str_) – Azure image cached resource group

  * **managed_identity** (_str_) – Azure Managed Identity




create()
    

Create a new cloud account

Returns:
    

a newly created cloud account

Return type:
    

`dataikuapi.fm.cloudaccounts.FMAzureCloudAccount`

_class _dataikuapi.fm.cloudaccounts.FMGCPCloudAccount(_client_ , _account_data_)
    

set_same_as_fm()
    

Use the same authentication as Fleet Manager

set_service_account_key(_project_id_ , _service_account_key_)
    

Use a Service Account JSON key based authentication

Parameters:
    

  * **project_id** (_str_) – GCP project

  * **service_account_key** (_str_) – Optional, service account key (JSON)




_class _dataikuapi.fm.cloudaccounts.FMGCPCloudAccountCreator(_client_ , _label_)
    

same_as_fm()
    

Use the same authentication as Fleet Manager

with_service_account_key(_project_id_ , _service_account_key_)
    

Use a Service Account JSON key based authentication

Parameters:
    

  * **project_id** (_str_) – GCP project

  * **service_account_key** (_str_) – Optional, service account key (JSON)




create()
    

Create a new cloud account

Returns:
    

a newly created cloud account

Return type:
    

`dataikuapi.fm.cloudaccounts.FMGCPCloudAccount`

## Fleet Manager Instances

_class _dataikuapi.fm.instances.FMInstance(_client_ , _instance_data_)
    

A handle to interact with a DSS instance. Do not create this directly, use `dataikuapi.fmclient.FMClient.get_instance()` or

  * `dataikuapi.fmclient.FMClientAWS.new_instance_creator()`

  * `dataikuapi.fmclient.FMClientAzure.new_instance_creator()`

  * `dataikuapi.fmclient.FMClientGCP.new_instance_creator()`




get_client()
    

Get a Python client to communicate with a DSS instance :return: a Python client to communicate with the target instance :rtype: [`dataikuapi.dssclient.DSSClient`](<client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient")

reprovision()
    

Reprovision the physical DSS instance

Returns:
    

the Future object representing the reprovision process

Return type:
    

`dataikuapi.fm.future.FMFuture`

deprovision()
    

Deprovision the physical DSS instance

Returns:
    

the Future object representing the deprovision process

Return type:
    

`dataikuapi.fm.future.FMFuture`

restart_dss()
    

Restart the DSS running on the physical instance

Returns:
    

the Future object representing the restart process

Return type:
    

`dataikuapi.fm.future.FMFuture`

save()
    

Update the instance

get_status()
    

Get the physical DSS instance’s status

Returns:
    

the instance status

Return type:
    

`dataikuapi.fm.instances.FMInstanceStatus`

delete()
    

Delete the DSS instance

Returns:
    

the Future object representing the deletion process

Return type:
    

`dataikuapi.fm.future.FMFuture`

start()
    

Start the DSS instance

Returns:
    

the Future object representing the starting process

Return type:
    

`dataikuapi.fm.future.FMFuture`

stop()
    

Stop the DSS instance

Returns:
    

the Future object representing the stopping process

Return type:
    

`dataikuapi.fm.future.FMFuture`

get_initial_password()
    

Get the initial DSS admin password.

Can only be called once

Returns:
    

a password for the ‘admin’ user.

reset_user_password(_username_ , _password_)
    

Reset the password for a user on the DSS instance

Parameters:
    

  * **username** (_string_) – login

  * **password** (_string_) – new password



Returns:
    

the Future object representing the password reset process

Return type:
    

`dataikuapi.fm.future.FMFuture`

replay_setup_actions()
    

Replay the setup actions on the DSS instance

Returns:
    

the Future object representing the replay process

Return type:
    

`dataikuapi.fm.future.FMFuture`

set_automated_snapshots(_enable_ , _period_ , _keep =0_)
    

Set the automated snapshot policy for this instance

Parameters:
    

  * **enable** (_boolean_) – Enable the automated snapshots

  * **period** (_int_) – The time period between 2 snapshot in hours

  * **keep** (_int_) – Optional, the number of snapshot to keep. Use 0 to keep all snapshots. Defaults to 0.




set_custom_certificate(_pem_data_)
    

Set the custom certificate for this instance

Only needed when Virtual Network HTTPS Strategy is set to Custom Certificate

Parameters:
    

**pem_data** (_str_) – The SSL certificate

list_snapshots()
    

List all the snapshots of this instance

Returns:
    

list of snapshots

Return type:
    

list of `dataikuapi.fm.instances.FMSnapshot`

get_snapshot(_snapshot_id_)
    

Get a snapshot of this instance

Parameters:
    

**snapshot_id** (_str_) – identifier of the snapshot

Returns:
    

Snapshot

Return type:
    

`dataikuapi.fm.instances.FMSnapshot`

snapshot(_reason_for_snapshot =None_)
    

Create a snapshot of the instance

Returns:
    

Snapshot

Return type:
    

`dataikuapi.fm.instances.FMSnapshot`

_class _dataikuapi.fm.instances.FMInstanceCreator(_client_ , _label_ , _instance_settings_template_id_ , _virtual_network_id_ , _image_id_)
    

with_dss_node_type(_dss_node_type_)
    

Set the DSS node type of the instance to create. The default node type is DESIGN.

Parameters:
    

**dss_node_type** (`dataikuapi.fm.instances.FMNodeType`) – the type of the dss node to create.

Return type:
    

`dataikuapi.fm.instances.FMInstanceCreator`

with_cloud_instance_type(_cloud_instance_type_)
    

Set the machine type for the DSS Instance

Parameters:
    

**cloud_instance_type** (_str_) – the machine type to be used for the instance

Return type:
    

`dataikuapi.fm.instances.FMInstanceCreator`

with_data_volume_options(_data_volume_type =None_, _data_volume_size =None_, _data_volume_size_max =None_, _data_volume_IOPS =None_, _data_volume_encryption =None_, _data_volume_encryption_key =None_)
    

Set the options of the data volume to use with the DSS Instance

Parameters:
    

  * **data_volume_type** (_str_) – Optional, data volume type

  * **data_volume_size** (_int_) – Optional, data volume initial size

  * **data_volume_size_max** (_int_) – Optional, data volume maximum size

  * **data_volume_IOPS** (_int_) – Optional, data volume IOPS

  * **data_volume_encryption** (`dataikuapi.fm.instances.FMInstanceEncryptionMode`) – Optional, encryption mode of the data volume

  * **data_volume_encryption_key** (_str_) – Optional, the encryption key to use when data_volume_encryption_key is FMInstanceEncryptionMode.CUSTOM



Return type:
    

`dataikuapi.fm.instances.FMInstanceCreator`

with_cloud_tags(_cloud_tags_)
    

Set the tags to be applied to the cloud resources created for this DSS instance

Parameters:
    

**cloud_tags** (_dict_) – a key value dictionary of tags to be applied on the cloud resources

Return type:
    

`dataikuapi.fm.instances.FMInstanceCreator`

with_fm_tags(_fm_tags_)
    

A list of tags to add on the DSS Instance in Fleet Manager

Parameters:
    

**fm_tags** (_list_) – Optional, list of tags to be applied on the instance in the Fleet Manager

Return type:
    

`dataikuapi.fm.instances.FMInstanceCreator`

_class _dataikuapi.fm.instances.FMAWSInstance(_client_ , _instance_data_)
    

set_elastic_ip(_enable_ , _elasticip_allocation_id_)
    

Set a public elastic ip for this instance

Parameters:
    

  * **enable** (_boolan_) – Enable the elastic ip allocation

  * **elasticip_allocation_id** (_str_) – AWS ElasticIP allocation ID




_class _dataikuapi.fm.instances.FMAWSInstanceCreator(_client_ , _label_ , _instance_settings_template_id_ , _virtual_network_id_ , _image_id_)
    

with_aws_root_volume_options(_aws_root_volume_size =None_, _aws_root_volume_type =None_, _aws_root_volume_IOPS =None_)
    

Set the options of the root volume of the DSS Instance

Parameters:
    

  * **aws_root_volume_size** (_int_) – Optional, the root volume size

  * **aws_root_volume_type** (_str_) – Optional, the root volume type

  * **aws_root_volume_IOPS** (_int_) – Optional, the root volume IOPS



Return type:
    

`dataikuapi.fm.instances.FMAWSInstanceCreator`

create()
    

Create the DSS instance

Returns:
    

a newly created DSS instance

Return type:
    

`dataikuapi.fm.instances.FMAWSInstance`

_class _dataikuapi.fm.instances.FMAzureInstance(_client_ , _instance_data_)
    

set_elastic_ip(_enable_ , _public_ip_id_)
    

Set a public elastic ip for this instance

Parameters:
    

  * **enable** (_boolan_) – Enable the elastic ip allocation

  * **public_ip_id** (_str_) – Azure Public IP ID




_class _dataikuapi.fm.instances.FMAzureInstanceCreator(_client_ , _label_ , _instance_settings_template_id_ , _virtual_network_id_ , _image_id_)
    

create()
    

Create the DSS instance

Returns:
    

a newly created DSS instance

Return type:
    

`dataikuapi.fm.instances.FMAzureInstance`

_class _dataikuapi.fm.instances.FMGCPInstance(_client_ , _instance_data_)
    

set_public_ip(_enable_ , _public_ip_id_)
    

Set a public ip for this instance

Parameters:
    

  * **enable** (_boolan_) – Enable the public ip allocation

  * **public_ip_id** (_str_) – GCP Public IP ID




_class _dataikuapi.fm.instances.FMGCPInstanceCreator(_client_ , _label_ , _instance_settings_template_id_ , _virtual_network_id_ , _image_id_)
    

create()
    

Create the DSS instance

Returns:
    

a newly created DSS instance

Return type:
    

`dataikuapi.fm.instances.FMGCPInstance`

_class _dataikuapi.fm.instances.FMInstanceEncryptionMode(_value_)
    

An enumeration.

NONE _ = 'NONE'_
    

DEFAULT_KEY _ = 'DEFAULT_KEY'_
    

TENANT _ = 'TENANT'_
    

CUSTOM _ = 'CUSTOM'_
    

_class _dataikuapi.fm.instances.FMInstanceStatus(_data_)
    

A class holding read-only information about an Instance. This class should not be created directly. Instead, use `FMInstance.get_status()`

_class _dataikuapi.fm.instances.FMSnapshot(_client_ , _instance_id_ , _snapshot_id_ , _snapshot_data =None_)
    

A handle to interact with a snapshot of a DSS instance. Do not create this directly, use `FMInstance.snapshot()`

get_info()
    

Get the information about this snapshot

Returns:
    

a dict

reprovision()
    

Reprovision the physical DSS instance from this snapshot

Returns:
    

the Future object representing the reprovision process

Return type:
    

`dataikuapi.fm.future.FMFuture`

delete()
    

Delete the snapshot

Returns:
    

the Future object representing the deletion process

Return type:
    

`dataikuapi.fm.future.FMFuture`

## Fleet Manager Virtual Networks

_class _dataikuapi.fm.virtualnetworks.FMVirtualNetwork(_client_ , _vn_data_)
    

save()
    

Update this virtual network.

delete()
    

Delete this virtual network.

Returns:
    

the Future object representing the deletion process

Return type:
    

`dataikuapi.fm.future.FMFuture`

set_fleet_management(_enable_ , _event_server =None_, _deployer_management ='NO_MANAGED_DEPLOYER'_, _govern_server =None_)
    

When enabled, all instances in this virtual network know each other and can centrally manage deployer and logs centralization

Parameters:
    

  * **enable** (_boolean_) – Enable or not the Fleet Management

  * **event_server** (_str_) – Optional, Node name of the node that should act as the centralized event server for logs concentration. Audit logs of all design, deployer and automation nodes will automatically be sent there.

  * **deployer_management** (_str_) – Optional, Accepts: \- “NO_MANAGED_DEPLOYER”: Do not manage the deployer. This is the default mode. \- “CENTRAL_DEPLOYER”: Central deployer. Recommended if you have more than one design node or may have more than one design node in the future. \- “EACH_DESIGN_NODE”: Deployer from design. Recommended if you have a single design node and want a simpler setup.

  * **govern_server** (_str_) – Optional, node name of the node that should act as the centralized Govern server.




set_https_strategy(_https_strategy_)
    

Set the HTTPS strategy for this virtual network

Parameters:
    

**https_strategy** (`dataikuapi.fm.virtualnetworks.FMHTTPSStrategy`) – the strategy to set

_class _dataikuapi.fm.virtualnetworks.FMVirtualNetworkCreator(_client_ , _label_)
    

with_internet_access_mode(_internet_access_mode_)
    

Set the Internet access mode

Parameters:
    

**internet_access_mode** (_str_) – The internet access mode of the instances created in this virtual network. Accepts “YES”, “NO”, “EGRESS_ONLY”. Defaults to “YES”

with_default_values()
    

Set the VPC and Subnet to their default values: the vpc and subnet of the FM instance

with_account(_cloud_account =None_, _cloud_account_id =None_)
    

Set the Cloud Account for this virtual network

Parameters:
    

  * **cloud_account** (`dataikuapi.fm.cloudaccounts.FMCloudAccount`) – The cloud account

  * **cloud_account_id** (_str_) – The cloud account identifier




with_auto_create_peering()
    

Automatically create the network peering when creating this virtual network

_class _dataikuapi.fm.virtualnetworks.FMAWSVirtualNetwork(_client_ , _vn_data_)
    

set_dns_strategy(_assign_domain_name_ , _aws_private_ip_zone53_id =None_, _aws_public_ip_zone53_id =None_)
    

Set the DNS strategy for this virtual network

Parameters:
    

  * **assign_domain_name** (_boolean_) – If false, don’t assign domain names, use ip_only

  * **aws_private_ip_zone53_id** (_str_) – Optional, AWS Only, the ID of the AWS Route53 Zone to use for private ip

  * **aws_public_ip_zone53_id** (_str_) – Optional, AWS Only, the ID of the AWS Route53 Zone to use for public ip




set_assign_public_ip(_public_ip =True_)
    

Sets whether the instances on this network will have a publicly accessible IP

Parameters:
    

**public_ip** (_bool_) – if False, the instances will not be accessible from outside AWS VPC

_class _dataikuapi.fm.virtualnetworks.FMAWSVirtualNetworkCreator(_client_ , _label_)
    

with_vpc(_aws_vpc_id_ , _aws_subnet_id_ , _aws_second_subnet_id =None_)
    

Set the VPC and Subnet to be used by the virtual network

Parameters:
    

  * **aws_vpc_id** (_str_) – ID of the VPC to use

  * **aws_subnet_id** (_str_) – ID of the subnet to use

  * **aws_second_subnet_id** (_str_) – ID of the second subnet to use




with_region(_aws_region_)
    

Set the region where the VPC should be found

Parameters:
    

**aws_region** (_str_) – the region of the VPC to use

with_auto_create_security_groups()
    

Automatically create the AWS Security Groups when creating this virtual network

with_aws_security_groups(_* aws_security_groups_)
    

Use pre-created AWS Security Groups

Parameters:
    

**aws_security_groups** (_str_) – Up to 5 security group ids to assign to the instances created in this virtual network

create()
    

Create a new virtual network

Returns:
    

a newly created network

Return type:
    

`dataikuapi.fm.virtualnetworks.FMAWSVirtualNetwork`

_class _dataikuapi.fm.virtualnetworks.FMAzureVirtualNetwork(_client_ , _vn_data_)
    

set_dns_strategy(_assign_domain_name_ , _azure_dns_zone_id =None_)
    

Set the DNS strategy for this virtual network

Parameters:
    

  * **assign_domain_name** (_boolean_) – If false, don’t assign domain names, use ip_only

  * **azure_dns_zone_id** (_str_) – Optional, Azure Only, the ID of the Azure DNS zone to use




set_assign_public_ip(_public_ip =True_)
    

Sets whether the instances on this network will have a publicly accessible IP

Parameters:
    

**public_ip** (_bool_) – if False, the instances will not be accessible from outside Azure Vnet

_class _dataikuapi.fm.virtualnetworks.FMAzureVirtualNetworkCreator(_client_ , _label_)
    

with_azure_virtual_network(_azure_vn_id_ , _azure_subnet_id_ , _azure_second_subnet_id =None_)
    

Setup the Azure Virtual Network and Subnet to be used by the virtual network

Parameters:
    

  * **azure_vn_id** (_str_) – Resource ID of the Azure Virtual Network to use

  * **azure_subnet_id** (_str_) – Subnet name of the first subnet

  * **azure_second_subnet_id** (_str_) – Subnet name of the second subnet




with_auto_update_security_groups(_auto_update_security_groups =True_)
    

Auto update the security groups of the Azure Virtual Network

Parameters:
    

**auto_update_security_groups** (_boolean_) – Optional, Auto update the subnet security group. Defaults to True

create()
    

Create a new virtual network

Returns:
    

a newly created network

Return type:
    

`dataikuapi.fm.virtualnetworks.FMAzureVirtualNetwork`

_class _dataikuapi.fm.virtualnetworks.FMGCPVirtualNetwork(_client_ , _vn_data_)
    

set_assign_public_ip(_public_ip =True_)
    

Sets whether the instances on this network will have a publicly accessible IP

Parameters:
    

**public_ip** (_bool_) – if False, the instances will not be accessible from outside GCP

set_location_for_created_resources(_project_id =None_, _zone =None_)
    

Set the location in GCP of the instances created using this virtual network

Parameters:
    

  * **project_id** (_str_) – Optional, the project in which instances should be created. If empty string, then the project of the FM instance is used

  * **zone** (_str_) – Optional, the zone in which instances should be created. If empty string, then the zone of the FM instance is used




set_dns_strategy(_assign_domain_name_ , _private_ip_zone_id =None_, _public_ip_zone_id =None_)
    

Set the DNS strategy for this virtual network

Parameters:
    

  * **assign_domain_name** (_boolean_) – If false, don’t assign domain names, use ip_only

  * **private_ip_zone_id** (_str_) – Optional, the ID of the Cloud DNS Zone to use for private ip

  * **public_ip_zone_id** (_str_) – Optional, the ID of the Cloud DNS Zone to use for public ip




_class _dataikuapi.fm.virtualnetworks.FMGCPVirtualNetworkCreator(_client_ , _label_)
    

with_vpc(_project_id_ , _network_ , _subnetwork_)
    

Setup the VPC which the virtual network will use

Parameters:
    

  * **project_id** (_str_) – ID of the project in which the network is defined

  * **network** (_str_) – name of the network

  * **subnetwork** (_str_) – name of the subnetwork




with_network_tags(_* network_tags_)
    

Use network tags on the instances created in the virtual network

Parameters:
    

**network_tags** (_str_) – network tags to assign to the instances created in this virtual network.

create()
    

Create the virtual network

Returns:
    

a newly created network

Return type:
    

`dataikuapi.fm.virtualnetworks.FMGCPVirtualNetwork`

_class _dataikuapi.fm.virtualnetworks.FMHTTPSStrategy(_data_ , _https_strategy_ , _http_redirect =False_)
    

_static _disable()
    

Use HTTP only

_static _self_signed(_http_redirect_)
    

Use self-signed certificates

Parameters:
    

**http_redirect** (_bool_) – If true, HTTP is redirected to HTTPS. If false, HTTP is disabled. Defaults to false

_static _custom_cert(_http_redirect_)
    

Use a custom certificate for each instance

Parameters:
    

**http_redirect** (_bool_) – If true, HTTP is redirected to HTTPS. If false, HTTP is disabled. Defaults to false

_static _lets_encrypt(_contact_mail_)
    

Use Let’s Encrypt to generate https certificates

Parameters:
    

**contact_mail** (_str_) – The contact email provided to Let’s Encrypt

## Fleet Manager Instance Templates

_class _dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplate(_client_ , _ist_data_)
    

save()
    

Update this template

delete()
    

Delete this template

Returns:
    

the Future object representing the deletion process

Return type:
    

`dataikuapi.fm.future.FMFuture`

add_setup_action(_setup_action_)
    

Add a setup action

Parameters:
    

**setup_action** (`dataikuapi.fm.instancesettingstemplates.FMSetupAction`) – the action to add

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplate`

set_setup_action_enabled_by_index(_index_ , _enabled =True_)
    

Enable or disable a setup action.

Specify the index of the setup action to update in the setupActions list. This sets the ‘enabled’ field in the action’s params dict.

Parameters:
    

  * **index** (_int_) – The index of the setup action to update (0-indexed)

  * **enabled** (_bool_) – Whether to enable (True) or disable (False) the action (default: True)



Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplate`

set_setup_action_enabled_by_action_type(_action_type_ , _index =0_, _enabled =True_)
    

Enable or disable a setup action.

Specify the setup action to update by its type and its index (the index-th setup action of this type will be updated). This sets the ‘enabled’ field in the action’s params dict.

Parameters:
    

  * **action_type** (_FMSetupActionType_) – The type of the setup action to update. Must be an FMSetupActionType enum.

  * **index** (_int_) – The index of the setup action to update within the list of setup actions of the correct type extracted from the setup actions list. First setup action in the list has index 0

  * **enabled** (_bool_) – Whether to enable (True) or disable (False) the action (default: True)



Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplate`

_class _dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplateCreator(_client_ , _label_)
    

create()
    

Create a new instance settings template.

Returns:
    

a newly created template

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplate`

with_setup_actions(_setup_actions_)
    

Add setup actions

Parameters:
    

**setup_actions** (list of `dataikuapi.fm.instancesettingstemplates.FMSetupActions`) – List of setup actions to be played on an instance

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplateCreator`

with_license(_license_file_path =None_, _license_string =None_)
    

Override global license

Parameters:
    

  * **license_file_path** (_str_) – Optional, load the license from a json file

  * **license_string** (_str_) – Optional, load the license from a json string



Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMInstanceSettingsTemplateCreator`

_class _dataikuapi.fm.instancesettingstemplates.FMAWSInstanceSettingsTemplateCreator(_client_ , _label_)
    

with_aws_keypair(_aws_keypair_name_)
    

Add an AWS Keypair to the DSS instance. Needed to get SSH access to the DSS instance, using the centos user.

Parameters:
    

**aws_keypair_name** (_str_) – Name of an AWS key pair to add to the instance.

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMAWSInstanceSettingsTemplateCreator`

with_startup_instance_profile(_startup_instance_profile_arn_)
    

Add an Instance Profile to be assigned to the DSS instance on startup

Parameters:
    

**startup_instance_profile_arn** (_str_) – ARN of the Instance profile assigned to the DSS instance at startup time

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMAWSInstanceSettingsTemplateCreator`

with_runtime_instance_profile(_runtime_instance_profile_arn_)
    

Add an Instance Profile to be assigned to the DSS instance when running

Parameters:
    

**runtime_instance_profile_arn** (_str_) – ARN of the Instance profile assigned to the DSS instance during runtime

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMAWSInstanceSettingsTemplateCreator`

with_restrict_aws_metadata_server_access(_restrict_aws_metadata_server_access =True_)
    

Restrict AWS metadata server access on the DSS instance.

Parameters:
    

**restrict_aws_metadata_server_access** (_boolean_) – Optional, If true, restrict the access to the metadata server access. Defaults to true

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMAWSInstanceSettingsTemplateCreator`

with_default_aws_api_access_mode()
    

The DSS Instance will use the Runtime Instance Profile to access AWS API.

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMAWSInstanceSettingsTemplateCreator`

with_keypair_aws_api_access_mode(_aws_access_key_id_ , _aws_keypair_storage_mode ='NONE'_, _aws_secret_access_key =None_, _aws_secret_access_key_aws_secret_name =None_, _aws_secrets_manager_region =None_)
    

DSS Instance will use an Access Key to authenticate against the AWS API.

Parameters:
    

  * **aws_access_key_id** (_str_) – AWS Access Key ID.

  * **aws_keypair_storage_mode** (_str_) – Optional, the storage mode of the AWS api key. Accepts “NONE”, “INLINE_ENCRYPTED” or “AWS_SECRETS_MANAGER”. Defaults to “NONE”

  * **aws_secret_access_key** (_str_) – Optional, AWS Access Key Secret. Only needed if keypair_storage_mode is “INLINE_ENCRYPTED”

  * **aws_secret_access_key_aws_secret_name** (_str_) – Optional, ASM secret name. Only needed if aws_keypair_storage_mode is “AWS_SECRET_MANAGER”

  * **aws_secrets_manager_region** (_str_) – Optional, Secret Manager region to use. Only needed if aws_keypair_storage_mode is “AWS_SECRET_MANAGER”



Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMAWSInstanceSettingsTemplateCreator`

_class _dataikuapi.fm.instancesettingstemplates.FMAzureInstanceSettingsTemplateCreator(_client_ , _label_)
    

with_ssh_key(_ssh_public_key_)
    

Add an SSH public key to the DSS Instance. Needed to access it through SSH, using the centos user.

Parameters:
    

**ssh_public_key** (_str_) – The content of the public key to add to the instance.

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMAzureInstanceSettingsTemplateCreator`

with_startup_managed_identity(_startup_managed_identity_)
    

Add a managed identity to be assign to the DSS instance on startup

Parameters:
    

**startup_managed_identity** (_str_) – Managed Identity ID

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMAzureInstanceSettingsTemplateCreator`

with_runtime_managed_identity(_runtime_managed_identity_)
    

Add a managed identity to be assign to the DSS instance when running

Parameters:
    

**runtime_managed_identity** (_str_) – Managed Identity ID

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMAzureInstanceSettingsTemplateCreator`

_class _dataikuapi.fm.instancesettingstemplates.FMGCPInstanceSettingsTemplateCreator(_client_ , _label_)
    

with_ssh_key(_ssh_public_key_)
    

Add an SSH public key to the DSS Instance. Needed to access it through SSH, using the centos user.

Parameters:
    

**ssh_public_key** (_str_) – The content of the public key to add to the instance.

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMGCPInstanceSettingsTemplateCreator`

with_restrict_metadata_server_access(_restrict_metadata_server_access =True_)
    

Restrict GCloud metadata server access on the DSS instance.

Parameters:
    

**restrict_metadata_server_access** (_boolean_) – Optional, If true, restrict the access to the metadata server access. Defaults to true

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMGCPInstanceSettingsTemplateCreator`

with_block_project_wide_keys(_block_project_wide_keys =True_)
    

Restrict GCloud metadata server access on the DSS instance.

Parameters:
    

**block_project_wide_keys** (_boolean_) – Optional, If true, block project-wide ssh keys on the instance. Defaults to true

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMGCPInstanceSettingsTemplateCreator`

with_runtime_service_account(_startup_service_account_)
    

Add a service account to be assigned to the DSS instance on startup

Parameters:
    

**startup_service_account** (_str_) – service account email

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMGCPInstanceSettingsTemplateCreator`

_class _dataikuapi.fm.instancesettingstemplates.FMSetupAction(_setupActionType_ , _params =None_)
    

_static _add_authorized_key(_ssh_key_)
    

Return an ADD_AUTHORIZED_KEY setup action

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMSetupAction`

_static _run_ansible_task(_stage_ , _yaml_string_)
    

Return a RUN_ANSIBLE_TASK setup action

Parameters:
    

  * **stage** (`dataikuapi.fm.instancesettingstemplates.FMSetupActionStage`) – the action stage

  * **yaml_string** (_str_) – a yaml encoded string defining the ansibles tasks to run



Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMSetupAction`

_static _install_system_packages(_packages_)
    

Return an INSTALL_SYSTEM_PACKAGES setup action

Parameters:
    

**packages** (_list_) – List of packages to install

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMSetupAction`

_static _setup_advanced_security(_basic_headers =True_, _hsts =False_)
    

Return a SETUP_ADVANCED_SECURITY setup action

Parameters:
    

  * **basic_headers** (_boolean_) – Optional, Prevent browsers to render Web content served by DSS to be embedded into a frame, iframe, embed or object tag. Defaults to True

  * **hsts** (_boolean_) – Optional, Enforce HTTP Strict Transport Security. Defaults to False



Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMSetupAction`

_static _install_jdbc_driver(_database_type_ , _url_ , _paths_in_archive =None_, _http_headers =None_, _http_username =None_, _http_password =None_, _datadir_subdirectory =None_)
    

Return a INSTALL_JDBC_DRIVER setup action

Parameters:
    

  * **database_type** (`dataikuapi.fm.instancesettingstemplates.FMSetupActionAddJDBCDriverDatabaseType`) – the database type

  * **url** (_str_) – The full address to the driver. Supports http(s)://, s3://, abs:// or file:// endpoints

  * **paths_in_archive** (_list_) – Optional, must be used when the driver is shipped as a tarball or a ZIP file. Add here all the paths to find the JAR files in the driver archive. Paths are relative to the top of the archive. Wildcards are supported.

  * **http_headers** (_dict_) – Optional, If you download the driver from a HTTP(S) endpoint, add here the headers you want to add to the query. This setting is ignored for any other type of download.

  * **http_username** (_str_) – Optional, If the HTTP(S) endpoint expect a Basic Authentication, add here the username. To explicitely specify which Assigned Identity use if the machine have several, set the client_id here. To authenticate with a SAS Token on Azure Blob Storage (not recommended), use “token” as the value here.

  * **http_password** (_str_) – Optional, If the HTTP(S) endpoint expect a Basic Authentication, add here the password. To authenticate with a SAS Token on Azure Blob Storage (not recommended), store the token in this field.

  * **datadir_subdirectory** (_str_) – Optional, Some drivers are shipped with a high number of JAR files along with them. In that case, you might want to install them under an additional level in the DSS data directory. Set the name of this subdirectory here. Not required for most drivers.



Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMSetupAction`

_static _setup_k8s_and_spark()
    

Return a SETUP_K8S_AND_SPARK setup action

Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMSetupAction`

_static _install_deprecated_python(_install_py36 =False_, _install_py37 =False_, _install_py38 =False_)
    

Return an INSTALL_DEPRECATED_PYTHON setup action

Parameters:
    

  * **install_py36** (_boolean_) – Install Python 3.6, optional (default: False)

  * **install_py37** (_boolean_) – Install Python 3.7, optional (default: False)

  * **install_py38** (_boolean_) – Install Python 3.8, optional (default: False)



Return type:
    

`dataikuapi.fm.instancesettingstemplates.FMSetupAction`

_class _dataikuapi.fm.instancesettingstemplates.FMSetupActionStage(_value_)
    

An enumeration.

after_dss_startup _ = 'after_dss_startup'_
    

after_install _ = 'after_install'_
    

before_install _ = 'before_install'_
    

_class _dataikuapi.fm.instancesettingstemplates.FMSetupActionAddJDBCDriverDatabaseType(_value_)
    

An enumeration.

mysql _ = 'mysql'_
    

mssql _ = 'mssql'_
    

oracle _ = 'oracle'_
    

mariadb _ = 'mariadb'_
    

snowflake _ = 'snowflake'_
    

athena _ = 'athena'_
    

bigquery _ = 'bigquery'_
    

## Fleet Manager Load Balancers

..autoclass:: dataikuapi.fm.loadbalancers.FMLoadBalancer ..autoclass:: dataikuapi.fm.loadbalancers.FMLoadBalancerCreator ..autoclass:: dataikuapi.fm.loadbalancers.FMLoadBalancerPhysicalStatus ..autoclass:: dataikuapi.fm.loadbalancers.FMAWSLoadBalancer ..autoclass:: dataikuapi.fm.loadbalancers.FMAWSLoadBalancerCreator ..autoclass:: dataikuapi.fm.loadbalancers.FMAzureLoadBalancer ..autoclass:: dataikuapi.fm.loadbalancers.FMAzureLoadBalancerCreator ..autoclass:: dataikuapi.fm.loadbalancers.FMAzureLoadBalancerTier

## Fleet Manager Tenant

_class _dataikuapi.fm.tenant.FMCloudAuthentication(_data_)
    

_static _aws_same_as_fm()
    

AWS Only: use the same authentication as Fleet Manager

_static _aws_iam_role(_role_arn_)
    

AWS Only: use an IAM Role

Parameters:
    

**role_arn** (_str_) – ARN of the IAM Role

_static _aws_keypair(_access_key_id_ , _secret_access_key_)
    

AWS Only: use an AWS Access Key

Parameters:
    

  * **access_key_id** (_str_) – AWS Access Key ID

  * **secret_access_key** (_str_) – AWS Secret Access Key




_static _azure(_subscription_ , _tenant_id_ , _environment_ , _client_id_)
    

Azure Only

Parameters:
    

  * **subscription** (_str_) – Azure Subscription

  * **tenant_id** (_str_) – Azure Tenant Id

  * **environment** (_str_) – Azure Environment

  * **client_id** (_str_) – Azure Client Id




_static _gcp(_project_id_ , _service_account_key_)
    

GCP Only

Parameters:
    

  * **project_id** (_str_) – GCP project

  * **service_account_key** (_str_) – Optional, service account key (JSON)




_class _dataikuapi.fm.tenant.FMCloudCredentials(_client_ , _cloud_credentials_)
    

A Tenant Cloud Credentials in the FM instance

set_cmk_key(_cmk_key_id_)
    

set_static_license(_license_file_path =None_, _license_string =None_)
    

Set a default static license for the DSS instances

Parameters:
    

  * **license_file_path** (_str_) – Optional, load the license from a json file

  * **license_string** (_str_) – Optional, load the license from a json string




set_azure_keyvault(_azure_keyvault_id_ , _azure_key_name_ , _azure_key_version_)
    

Set the Azure Key Vault configuration

Parameters:
    

  * **azure_keyvault_id** (_str_) – the Azure Key Vault resource ID

  * **azure_key_name** (_str_) – the name of the key to use in the vault

  * **azure_key_version** (_str_) – the version of the key to use in the vault




set_aws_cmk(_aws_cmk_id_)
    

Set AWS Customer Managed Key (CMK) configuration

Parameters:
    

**aws_cmk_id** (_str_) – the ID of the key to use

set_gcp_key(_gcp_location_id_ , _gcp_key_ring_ , _gcp_crypto_key_ , _gcp_crypto_key_version_)
    

Set GCP Key Management Service (KMS) configuration

Parameters:
    

  * **gcp_location_id** (_str_) – the location ID of the key ring

  * **gcp_key_ring** (_str_) – the name of the key ring

  * **gcp_crypto_key** (_str_) – the name of the key to use in the key ring

  * **gcp_crypto_key_version** (_str_) – the version of the key to use in the key ring




set_automatically_updated_license(_license_token_)
    

Set an automatically updated license for the DSS instances

Parameters:
    

**license_token** (_str_) – License token

set_authentication(_authentication_)
    

Set the authentication for the tenant

Parameters:
    

**authentication** (`dataikuapi.fm.tenant.FMCloudAuthentication`) – the authentication to be used

save()
    

Saves back the settings to the project

_class _dataikuapi.fm.tenant.FMCloudTags(_client_ , _cloud_tags_)
    

A Tenant Cloud Tags in the FM instance

_property _tags
    

save()
    

Saves the tags on FM

## Fleet Manager Future

_class _dataikuapi.fm.future.FMFuture(_client_ , _job_id_ , _state=None_ , _result_wrapper= <function FMFuture.<lambda>>_)
    

A future on the DSS instance

_static _from_resp(_client_ , _resp_ , _result_wrapper= <function FMFuture.<lambda>>_)
    

Creates a DSSFuture from a parsed JSON response

Return type:
    

`dataikuapi.fm.future.FMFuture`

_classmethod _get_result_wait_if_needed(_client_ , _ret_)
    

abort()
    

Abort the future

get_state()
    

Get the status of the future, and its result if it’s ready

peek_state()
    

Get the status of the future, and its result if it’s ready

get_result()
    

Get the future result if it’s ready, raises an Exception otherwise

has_result()
    

Checks whether the future has a result ready

wait_for_result()
    

Wait and get the future result