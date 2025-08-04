use crate::sudoku_parser::SudokuData;

fn print_atleast_one_number_per_field_constraint(data: &SudokuData, x: u32, y: u32) {
    for n in 0..data.n * data.n {
        print!("{} ", data.var(x, y, n));
    }
    println!("0");
}

fn print_number_at_pos_not_equal(
    data: &SudokuData,
    x1: u32,
    y1: u32,
    x2: u32,
    y2: u32,
) {
    assert_ne!((x1, y1), (x2, y2));

    for n in 0..data.n * data.n {
        let v1 = data.var(x1, y1, n);
        let v2 = data.var(x2, y2, n);
        println!("{} {} 0", -v1, -v2);
    }
}

fn print_different_values_in_row_constraint(data: &SudokuData, y: u32) {
    for (x1, y1, _) in data.iter_row(y) {
        for (x2, y2, _) in data.iter_row(y).skip(1 + x1 as usize) {
            print_number_at_pos_not_equal(data, x1, y1, x2, y2);
        }
    }
}

fn print_different_values_in_col_constraint(data: &SudokuData, x: u32) {
    for (x1, y1, _) in data.iter_col(x) {
        for (x2, y2, _) in data.iter_col(x).skip(1 + y1 as usize) {
            print_number_at_pos_not_equal(data, x1, y1, x2, y2);
        }
    }
}

fn print_different_values_in_tile_constraint(data: &SudokuData, x: u32, y: u32) {
    for (x1, y1, _) in data.iter_tile(x, y) {
        for (x2, y2, _) in data.iter_tile(x, y).filter(|(x2, y2, _)| {
            *x2 != x1
                && *y2 != y1
                && y1 * data.n * data.n + x1 < *y2 * data.n * data.n + *x2
        }) {
            print_number_at_pos_not_equal(data, x1, y1, x2, y2);
        }
    }
}

pub fn encode(sudoku: SudokuData) {
    for (x, y, _) in sudoku.iter_fields() {
        print_atleast_one_number_per_field_constraint(&sudoku, x, y);
    }
    eprintln!("atleast one number per field constraint generated.");

    for y in 0..sudoku.n * sudoku.n {
        print_different_values_in_row_constraint(&sudoku, y);
    }
    eprintln!("different values in row constriant generated.");

    for x in 0..sudoku.n * sudoku.n {
        print_different_values_in_col_constraint(&sudoku, x);
    }
    eprintln!("different values in col constraint generated.");

    let n = sudoku.n;
    for (gx, gy) in (0..n)
        .map(move |gy| (0..n).map(move |gx| (gx, gy)))
        .flatten()
    {
        print_different_values_in_tile_constraint(&sudoku, gx, gy);
    }
    eprintln!("different values in tile constraint generated.");

    for (x, y, i) in sudoku.iter_fields().filter(|(_, _, i)| *i != 0) {
        println!("{} 0", sudoku.var(x, y, i - 1))
    }
    eprintln!("known value constraint generated");
}
