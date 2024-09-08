import random
import pandas as pd
from faker import Faker
from scipy.stats import norm

# Define income ranges based on education level
income_ranges = {
    "Diploma": (1000, 3000),
    "Bachelor's Degree": (4000, 6000),
    "Master's Degree": (7000, 10000)
}

def generate_demographic_data_with_constraints(num_records, age_range, gender_ratio, income_ranges, education_levels, locations):
    Faker.seed(42)
    fake = Faker()

    data = []
    for _ in range(num_records):
        age = random.randint(age_range[0], age_range[1])
        gender = "Male" if random.random() < gender_ratio else "Female"
        education_level = random.choice(education_levels)
        
        # Sample income based on education level
        income = random.randint(income_ranges[education_level][0], income_ranges[education_level][1])
        
        # Add correlation: let's increase income slightly with age for Bachelor's and Master's
        if education_level != "Diploma":
            income += int((age - 20) * 100)  # Assume income grows RM100 per year after age 20 for higher education

        location = random.choice(locations)

        data.append({
            "age": age,
            "gender": gender,
            "income": income,
            "education_level": education_level,
            "location": location
        })

    return data

# Usage of the function
num_records = 10000
age_range = (20, 45)
gender_ratio = 0.5  # 50% male, 50% female
education_levels = ["Diploma", "Bachelor's Degree", "Master's Degree"]
locations = ["Kuala Lumpur", "Putrajaya", "Cyberjaya"]

# Generate the synthetic data
synthetic_data = generate_demographic_data_with_constraints(num_records, age_range, gender_ratio, income_ranges, education_levels, locations)

# Convert to DataFrame
df = pd.DataFrame(synthetic_data)

# Save the DataFrame to a CSV file
csv_filename = 'synthetic_demographic_data_with_constraints.csv'
df.to_csv(csv_filename, index=False)

print(f"Data saved to {csv_filename}")
print(df.head())
