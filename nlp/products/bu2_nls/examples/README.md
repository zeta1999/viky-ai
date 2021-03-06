This directory contains a few examples fr testing some features.

Setup
=====

Copy directories packages and requests into the working directory:
```
ln -nfs ${OG_REPO_PATH}/products/bu2_nls/examples/packages $OG_REPO_PATH/ship/debug/packages
ln -nfs ${OG_REPO_PATH}/products/bu2_nls/examples/requests $OG_REPO_PATH/ship/debug/requests
cd $OG_REPO_PATH/ship/debug
```

List of examples
=====

Simple example:
```
./ognlp -c packages/aller_de_a.json -i requests/r_i_want_to_go_from_new_york_to_barcelona.json
```

Simple recursive definition:
```
./ognlp -c packages/go_town.json -i requests/r_go_town.json
```

Recursive definition of hotel features, thus defining an infinite list of hotel features:
```
./ognlp -c packages/packages_want-hotel.json -c packages/packages_pg-building-feature.json -i requests/r_hotel_with_feature.json
./ognlp -c packages/packages_pg-building-feature.json -i requests/r_with_features.json
```

Different tests for any:
```
./ognlp -c packages/aller_de_a_plus_any.json -i requests/r_i_want_to_go_from_tokyo_to_paris.json
./ognlp -c packages/aller_de_a_plus_any.json -i requests/r_i_want_to_go_from_new_york_to_barcelona.json
./ognlp -c packages/aller_de_a_plus_any.json -i requests/r_i_want_to_go_from_new_york_to_paris.json
./ognlp -c packages/packages_pg-building-feature-any.json -i requests/r_with_features_any.json
```

Any défini dans une expression avec du texte directement
```
./ognlp -c packages/package_any_text.json -i requests/r_any_text.json
```

Showing explanation :
```
./ognlp -c packages/aller_de_a_plus_any.json -i requests/r_i_want_to_go_from_new_york_to_paris_explanation.json
```

Set trace for a request (two requests, one with trace and the other without) :
```
./ognlp -c packages/aller_de_a_plus_any.json -i requests/r_i_want_to_go_from_new_york_to_paris_trace.json
```

First example of working with solutions:
```
./ognlp -c packages/aller_de_a_plus_any_solution.json -i requests/r_i_want_to_go_from_new_york_to_paris.json
```

List of values in solutions :
```
./ognlp -c packages/packages_pg-building-feature-solution.json -i requests/r_with_features.json
```

Better linguistic structuration:
```
./ognlp -c packages/want_go_from_to_any_solution.json -i requests/r_to_great_paris_from_wonderful_new_york_i_really_want_to_go.json
./ognlp -c packages/want_go_from_to_any_solution.json -i requests/r_i_really_want_to_go_to_great_paris_from_wonderful_new_york.json
./ognlp -c packages/want_go_from_to_any_solution.json -i requests/r_to_great_paris_i_really_want_to_go_from_wonderful_new_york.json
```

Number in letters:
```
./ognlp -c packages/package_number_letters.json -i requests/r_number_letters_0_99_fr.json
./ognlp -c packages/package_number_letters.json -i requests/r_number_letters_100_199_fr.json
```

Number in digits:
```
./ognlp -c packages/package_number_digits.json -i requests/r_number_digit.json
./ognlp -c packages/package_number_digits.json -i requests/r_number_digits.json
```


Number in digits or letters:
```
./ognlp -c packages/package_number.json -c packages/package_number_digits.json -c packages/package_number_letters.json -i requests/r_numbers.json
```

hotel example:
```
./ognlp -c packages/package_building_features-v2.json -i requests/r_building_features-v2.json
./ognlp -c packages/package_number_people.json -c packages/package_number.json -c packages/package_number_digits.json -c packages/package_number_letters.json -i requests/r_number_people.json
./ognlp -c packages/package_number_people.json -c packages/package_number.json -c packages/package_number_digits.json -c packages/package_number_letters.json -c packages/package_building_features-v2.json -c packages/package_hotel_features.json -i requests/r_hotel_features.json
./ognlp -c packages/package_number_people.json -c packages/package_number.json -c packages/package_number_digits.json -c packages/package_number_letters.json -c packages/package_building_features-v2.json -c packages/package_hotel_features.json -c  packages/package_want.json -c packages/package_hotel.json -c packages/package_want_hotel_features.json -i requests/r_want_hotel_features.json
```

Dates:
```
./ognlp -c packages/package_number.json -c packages/package_number_digits.json -c packages/package_number_letters.json -c packages/package_date.json -i requests/r_date_day_month_year.json
```

why-not-working:
```
./ognlp -c packages/package_number.json -c packages/package_number_digits.json -c packages/package_number_letters.json -c packages/package_date_why.json -i requests/r_date_why.json
```

Simple test on language:
```
./ognlp -c packages/package_language_simple.json -i requests/r_language_simple.json
```

Simple test on warning:
```
./ognlp -c packages/package_warning_simple.json -i requests/r_warning_simple.json
```

Interpretation whatever-animal-bad can always be replaced by whatever-animal-good:
```
./ognlp -c packages/package_deep_any.json -i requests/r_deep_any.json
```

Double alias are working properly:
```
./ognlp -c packages/package_double_alias.json -i requests/r_double_alias.json
```

Exemple sur la limitation de l'algorithme:
```
./ognlp -c packages/package_limit_algo.json -i requests/r_limit_algo.json
```

Auto-complete:
```
ognlp -c packages/package_autocomplete.json -i requests/r_autocomplete.json
```

Summary of list of examples
=====

```
./ognlp -c packages/aller_de_a.json -i requests/r_i_want_to_go_from_new_york_to_barcelona.json
./ognlp -c packages/packages_want-hotel.json -c packages/packages_pg-building-feature.json -i requests/r_hotel_with_feature.json
./ognlp -c packages/packages_pg-building-feature.json -i requests/r_with_features.json
./ognlp -c packages/go_town.json -i requests/r_go_town.json
./ognlp -c packages/aller_de_a_plus_any.json -i requests/r_i_want_to_go_from_tokyo_to_paris.json
./ognlp -c packages/aller_de_a_plus_any.json -i requests/r_i_want_to_go_from_new_york_to_barcelona.json
./ognlp -c packages/aller_de_a_plus_any.json -i requests/r_i_want_to_go_from_new_york_to_paris.json
./ognlp -c packages/packages_pg-building-feature-any.json -i requests/r_with_features_any.json
./ognlp -c packages/aller_de_a_plus_any.json -i requests/r_i_want_to_go_from_new_york_to_paris_explanation.json
./ognlp -c packages/aller_de_a_plus_any.json -i requests/r_i_want_to_go_from_new_york_to_paris_trace.json
./ognlp -c packages/aller_de_a_plus_any_solution.json -i requests/r_i_want_to_go_from_new_york_to_paris.json
./ognlp -c packages/packages_pg-building-feature-solution.json -i requests/r_with_features.json
./ognlp -c packages/want_go_from_to_any_solution.json -i requests/r_to_great_paris_from_wonderful_new_york_i_really_want_to_go.json
./ognlp -c packages/want_go_from_to_any_solution.json -i requests/r_i_really_want_to_go_to_great_paris_from_wonderful_new_york.json
./ognlp -c packages/want_go_from_to_any_solution.json -i requests/r_to_great_paris_i_really_want_to_go_from_wonderful_new_york.json
./ognlp -c packages/package_number_letters.json -i requests/r_number_letters_0_99_fr.json
./ognlp -c packages/package_number_letters.json -i requests/r_number_letters_100_199_fr.json
./ognlp -c packages/package_number_digits.json -i requests/r_number_digit.json
./ognlp -c packages/package_number_digits.json -i requests/r_number_digits.json
./ognlp -c packages/package_number.json -c packages/package_number_digits.json -c packages/package_number_letters.json -i requests/r_numbers.json
./ognlp -c packages/package_building_features-v2.json -i requests/r_building_features-v2.json
./ognlp -c packages/package_number_people.json -c packages/package_number.json -c packages/package_number_digits.json -c packages/package_number_letters.json -i requests/r_number_people.json
./ognlp -c packages/package_number_people.json -c packages/package_number.json -c packages/package_number_digits.json -c packages/package_number_letters.json -c packages/package_building_features-v2.json -c packages/package_hotel_features.json -i requests/r_hotel_features.json
./ognlp -c packages/package_number.json -c packages/package_number_digits.json -c packages/package_number_letters.json -c packages/package_date.json -i requests/r_date_day_month_year.json
```


