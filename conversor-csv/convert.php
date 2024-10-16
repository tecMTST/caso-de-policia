<?php

declare(strict_types=1);

function readCsv(string $filename)
{
    $fh = fopen($filename, 'r');
    if (!$fh) {
        throw new RuntimeException("Could not open file {$filename}");
    }

    $firstLine = fgets($fh);
    // Trim away BOM marker if present
    if (substr($firstLine, 0, 3) === "\xEF\xBB\xBF") {
        $firstLine = substr($firstLine, 3);
    }

    $rows = [
        str_getcsv($firstLine, separator: ';'),
    ];
    while (false !== ($row = fgetcsv($fh, separator: ';'))) {
        // Skip empty rows
        if (implode('', $row) === '') {
            continue;
        }

        $rows[] = array_map(static function (string $value) {
            if (is_numeric($value)) {
                if (is_float($value)) {
                    return (float) $value;
                }

                return (int) $value;
            }

            if (is_bool($value)) {
                return (bool) $value;
            }

            return (string) $value;
        }, $row);
    }

    $header = array_shift($rows);
    $data = [];
    foreach ($rows as $row) {
        $data[] = array_combine($header, $row);
    }

    return $data;
}

$config = readCsv(__DIR__ . '/../assets/dados/config.csv');
$noticias = readCsv(__DIR__ . '/../assets/dados/noticias.csv');
$sugestoes = readCsv(__DIR__ . '/../assets/dados/sugestoes.csv');

$output = json_encode([
    'Configuracoes' => $config[0],
    'Noticias' => $noticias,
    'Sugestoes' => $sugestoes,
]);

file_put_contents(__DIR__ . '/../projeto/Scripts/Data/GameData.json', $output);
