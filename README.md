Here's a concise README for your repository:

---

# Speak-like-Harry-potter

A fun program that finds sentences in the Harry Potter books that are closest to the inputted text. It uses vectorized sentence embeddings and comparisons to return the most relevant sentences from the dataset.

## Features
- Takes an input sentence and compares it with sentences from the Harry Potter series.
- Returns the most similar sentence based on vector comparison.

## Files
- **Harry_potter.jl**: The core program written in Julia that handles sentence comparisons.
- **drac_sent_vec.csv**: Pre-calculated sentence vectors for sentences in the dataset.
- **drac_sentences.csv**: The dataset containing sentences from the Harry Potter books.

## How It Works
1. The input sentence is vectorized.
2. The vector is compared to the pre-calculated sentence vectors from the Harry Potter books.
3. The most similar sentence is returned.

## Usage
To use the program, run the `Harry_potter.jl` script in Julia. Make sure the sentence vector and dataset files are in the same directory.

## Future Enhancements
- Add support for additional books.
- Improve sentence vectorization techniques.

---

You can adjust this based on the specifics of your project!
