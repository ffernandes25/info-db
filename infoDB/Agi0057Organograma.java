package model;

import java.io.Serializable;
import java.time.LocalDate;

public class Agi0057Organograma implements Serializable {

	private String idDepartamento;
	private Long idCargo;
	private String dsCargo;
	private String nmFuncionario;
	private Long idCargoPai;
	private LocalDate dtAtualizacao;
	private String nmUsuario;

	public Agi0057Organograma() {
	}

	public String getIdDepartamento() {
		return idDepartamento;
	}

	public void setIdDepartamento(String idDepartamento) {
		this.idDepartamento = idDepartamento;
	}

	public Long getIdCargo() {
		return idCargo;
	}

	public void setIdCargo(Long idCargo) {
		this.idCargo = idCargo;
	}

	public String getDsCargo() {
		return dsCargo;
	}

	public void setDsCargo(String dsCargo) {
		this.dsCargo = dsCargo;
	}

	public String getNmFuncionario() {
		return nmFuncionario;
	}

	public void setNmFuncionario(String nmFuncionario) {
		this.nmFuncionario = nmFuncionario;
	}

	public Long getIdCargoPai() {
		return idCargoPai;
	}

	public void setIdCargoPai(Long idCargoPai) {
		this.idCargoPai = idCargoPai;
	}

	public LocalDate getDtAtualizacao() {
		return dtAtualizacao;
	}

	public void setDtAtualizacao(LocalDate dtAtualizacao) {
		this.dtAtualizacao = dtAtualizacao;
	}

	public String getNmUsuario() {
		return nmUsuario;
	}

	public void setNmUsuario(String nmUsuario) {
		this.nmUsuario = nmUsuario;
	}

}