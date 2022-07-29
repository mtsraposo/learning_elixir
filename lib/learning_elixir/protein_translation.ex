defmodule ProteinTranslation do
  @codon_to_protein %{
    UGU: "Cysteine",
    UGC: "Cysteine",
    UUA: "Leucine",
    UUG: "Leucine",
    AUG: "Methionine",
    UUU: "Phenylalanine",
    UUC: "Phenylalanine",
    UCU: "Serine",
    UCC: "Serine",
    UCA: "Serine",
    UCG: "Serine",
    UGG: "Tryptophan",
    UAU: "Tyrosine",
    UAC: "Tyrosine",
    UAA: "STOP",
    UAG: "STOP",
    UGA: "STOP"
  }
  @valid_codons @codon_to_protein |> Map.keys() |> Enum.map(&Atom.to_string(&1))

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {:ok, list(String.t())} | {:error, String.t()}
  def of_rna(rna) do
    rna
    |> chunk_by_codon()
    |> to_peptides()
    |> return_protein()
  end

  defp chunk_by_codon(rna) do
    rna
    |> String.graphemes()
    |> Enum.chunk_every(3)
    |> Enum.map(&Enum.join(&1))
  end

  defp to_peptides(rna) do
    rna
    |> Enum.reduce_while([], &append_peptide(&1, &2))
  end

  defp append_peptide(codon, protein) do
    peptide = of_codon(codon)
    do_append(peptide, protein)
  end

  defp do_append({:error, _}, _protein), do: {:halt, :error}
  defp do_append({:ok, "STOP"}, protein), do: {:halt, protein}
  defp do_append({:ok, peptide}, protein), do: {:cont, [peptide | protein]}

  defp return_protein(:error), do: {:error, "invalid RNA"}
  defp return_protein(protein), do: {:ok, Enum.reverse(protein)}

  @doc """
  Given a codon, return the corresponding protein
  """
  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon)
      when codon in @valid_codons do
    {:ok, Map.get(@codon_to_protein, String.to_atom(codon))}
  end

  def of_codon(codon) do
    {:error, "invalid codon"}
  end
end
