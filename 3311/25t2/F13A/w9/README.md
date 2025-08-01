## Today: Relational Design Theory

## Tips on Assignment 2
- **style feedback from assignment 1**
    - if you find yourself copying and pasting code... use helper views or helper functions!!!
    - avoid super long lines: 100-120 characters max is a good range
    - casing should be consistent: either capitalised keywords or non-capitalised
    - indentation should be consistent:
        ```sql
            # bad >>>:(
            SELECT
                name
                age
            FROM
                    table
            WHERE
                age < 50
            
            

            # good :)
            SELECT
                name
                age
            FROM
                table
            WHERE
                age < 50
            
        ```
    - sorry ik that this course doesn't have an official style guide which can make it hard to know what is acceptable and what's not but just try to generally apply the style concepts you've learnt in previous COMP courses i.e. be consistent, avoid repetition, avoid overly long lines etc.
    - if you feel like you really need a style guide to follow you can follow this one https://docs.telemetry.mozilla.org/concepts/sql_style (note: not officially endorsed by this course)
        - beware: where it mentions to always specify join type don't worry about it too much
- **as we're coming close to submission: double check you have submitted correctly!!**
    - either though webCMS or using `3311 classrun -check ass1`

## Good Database Design
- Ensures the database meets requirements and supports intended queries
- Reduces **redundancy**
    - Leads to **more efficient storage** (don't store redundant data)
    - Minimizes probability of **data corruption/inconsistency**
    - However, redundancy might lead to improved performance (saves the overhead of joining tables together)

## Relational Design Theory
- Provides the formal rules and principles for structuring data in a relational database
- Helps us identify and eliminate redundancy through concepts like functional dependencies and normal forms
- Guides the process of normalization -> helps us acheive good database design :)

## Functional Dependency (fd)
Describes relationships between sets of attributes  
- **Determinant**: X → **Dependent**: Y  
    - can be read as Y is functionally dependent on X
    - or X determines Y
- Formal Definition: 
    - For all tuples t1 and t2 in a relation R, if `t1[X] = t2[X]`, then `t1[Y] = t2[Y]`.
- In casual terms: 
    - X → Y if two rows (tuples) have the same value for X, they must have the same value for Y.
- **Example: Valid Functional Dependencies**
    - Suppose we have the following `Students` table:

        | student_id | name  | email             |
        |------------|-------|-------------------|
        | 1001       | Alice | alice@unsw.edu.au |
        | 1002       | Bob   | bob@unsw.edu.au   |
        | 1003       | Alice | alice2@unsw.edu.au |

        From this data:

        - `student_id → name`: valid FD  
        Each student ID maps to exactly one name

        - `student_id → email`: valid FD  
        Each student ID has exactly one email


- **Example: Invalid Functional Dependency**
    - Looking at the same table:
        - `name → email` is **not a valid FD**, because the name "Alice" appears multiple times with different email addresses:

        | name  | email             |
        |-------|-------------------|
        | Alice | alice@unsw.edu.au |
        | Alice | alice2@unsw.edu.au |

        Thus, `name` does **not uniquely determine** `email`.

## Inference Rules

**Armstrong's 3 rules:**
- Used to simplify fds
1. Reflexivity: `X → X`  
2. Augmentation: `X → Y => XZ → YZ`  
3. Transitivity: `X → Y, Y → Z => X → Z`  

**Useful derived rules:**
- Additivity: `X → Y, X → Z => X → YZ`
- Projectivity: `X → YZ => X → Y, X → Z`  
- Pseudotransitivity: `X → Y, YZ → W => XZ → W`  

## Closures

**Closures on fds**: Set of all derivable fds  
- the largest collection of dependencies that can be derived from F is called the closure of F and is denoted as F
- but this is rly large... so instead we define closures on a set of attributes instead

**Closures on set of attributes**  
- X⁺ = {set of derivable attributes}

### To compute closure X⁺:
1. Initialise closure set {X}  
2. For all fds A → B:  
   If A ⊆ closure set, add B to closure  
3. Repeat step 2 until no more attributes can be added  

## Superkey and Candidate Key
- A **superkey** of relation R is a set of attributes whose closure includes all attributes in R
    - essentially one or more attributes that can be used to uniquely identify a tuple
    - from example above:
        - `{student_id}`
        - `{student_id, name}`
        - `{student_id, name, email}`
        - `{email}`
        - and so on...
- A **candidate key** is a minimal superkey  
  - Candidate for a primary key 
  - has no redundant attributes i.e. cannot be reduced by removing any attributes without losing uniqueness property
    - so what's the candidate key for the above example...?
    - Remember that attributes that never appear in the RHS of any FDs must be in the candidate keys, as they can never be determined otherwise.

## Normalisation and Normal Forms
- Normalisation is decomposing a relation into smaller relations to remove redundancy  
- Normal Forms: 1NF → 5NF  
  - 1NF: most redundant (like a single table spreadsheet)  
  - 5NF: least redundant  
- Focus for this course: **3NF** and **BCNF (aka 3.5NF)**  
- A schema is in xNF if **all its relations** are in xNF  

## 3NF and BCNF

**Conditions on fds (X → Y):**
1. X → Y is trivial (Y ⊆ X)  
2. X is a superkey  
3. Y is a subset of a candidate key (primary attribute)  

- Schema is in **3NF** if any of (1), (2), or (3) hold  
- Schema is in **BCNF** if only (1) or (2) hold  
- BCNF is a stricter version of 3NF  


## Checking if 3NF
- A relation is in 3NF if, for every functional dependency X -> Y, at least one of the following holds:
1. X is a superkey.
2. Y is a prime attribute (i.e., part of some candidate key).

Steps to Check 3NF:
**Steps to Check 3NF:**

1. Identify all candidate keys of the relation.
2. Identify all prime attributes (attributes that are part of any candidate key).
3. For each functional dependency X -> Y:
    - Verify if X is a superkey.
    - If X is not a superkey, check if each attribute in Y is a prime attribute.
    - If any functional dependency violates both conditions, the relation is not in 3NF

## 3NF Decomposition

**Steps:**
1. Compute minimal cover: combine dependencies with a common right hand side where possible
2. For all fds A → B in minimal cover, create new relation/table with attributes AB  
3. If none of the newly created relations contain a candidate key, create a new relation with attributes of any candidate key  

## Minimal Cover
- A minimal cover is a simplified version of a set of functional dependencies (FDs) that is:
1. Equivalent to the original set (i.e., has the same closure),
2. Minimal — meaning:
    - Every FD has a single attribute on the right-hand side
    - There are no redundant attributes on the left-hand side (LHS)
    - There are no redundant FDs in the set

**Steps:**
1. Convert fds into canonical form (e.g., A → BC becomes A → B and A → C)  
2. Reduce multi-attribute determinants (reduce LHS)  
3. Remove redundant fds  

(steps 2 and 3 can sometimes be done by inspection)

## Checking if BCNF
- A relation is in BCNF if, for every non-trivial functional dependency X -> Y, X is a superkey.
- Steps to Check BCNF:
1. Identify all candidate keys of the relation.
2. For each functional dependency X -> Y in the relation:
    - Verify if X is a superkey.
    - If any functional dependency exists where X is not a superkey, the relation is not in BCNF.

## BCNF Decomposition

**Steps:**

```text
while exists a relation Ri not in BCNF:
    find FD X → Y in Ri that violates BCNF
    decompose Ri into:
        R1 = X ∪ Y
        R2 = Ri - (Y - X)

- remember to simplify fds as you go so the fds only include attributes present in the relation