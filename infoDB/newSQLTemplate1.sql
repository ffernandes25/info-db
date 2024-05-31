create or replace package body sini7070_008 is

	/******************************************************************
        Author  : Michael Dossa
        Created : 02/04/2012
        Purpose : Package com rotinas aviso montadora.
        ******************************************************************/
	/***********************************************************************************
        prc_tipo_informante
            Author  : Michael Dossa
            Created : 02/04/2012
            Purpose : Procedure para retornar cdigo e descrio dos tipos de informante.
            ***********************************************************************************/
	procedure prc_tipo_informante(p_cursor out tab_prc_tipo_informante,
				      p_mens   out varchar2) is
	begin
		open p_cursor for
			select rv_low_value id_tipo_informante,
			       upper(substr(rv_meaning, 1, 15)) ds_tipo_informante
			  from automovel_ref_codes
			 where rv_domain = 'SINISTRO TIPO INFORMANTE'
			 order by id_tipo_informante, ds_tipo_informante;
	exception
		when others then
			p_mens := 'SINI7070_008.PRC_TIPO_INFORMANTE - Problemas ao excecutar procedure - ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			return;
	end;

	/***********************************************************************************
        prc_tipo_ocorrencia
            Author  : Michael Dossa
            Created : 02/04/2012
            Purpose : Procedure que retorna os tipos de ocorrencia.
            ***********************************************************************************/
	procedure prc_tipo_ocorrencia(p_cd_tipo_bem_segurado        in number,
				      p_cd_caracteristica_bem_segur in number,
				      p_cd_ramo                     in number,
				      p_cursor                      out tab_prc_tipo_ocorrencia,
				      p_mens                        out varchar2) is
	begin
		open p_cursor for
			select snr.cd_natureza_sinistro,
			       sn.ds_natureza_sinistro
			  from sinistro_natureza_ramo snr,
			       sinistro_natureza      sn
			 where snr.cd_natureza_sinistro =
			       sn.cd_natureza_sinistro
			   and snr.cd_tipo_bem_segurado =
			       p_cd_tipo_bem_segurado
			   and snr.cd_caracteristica_bem_segur =
			       p_cd_caracteristica_bem_segur
			   and snr.cd_ramo = p_cd_ramo
			   and snr.id_situacao = 1
			 order by 2;
	exception
		when others then
			p_mens := 'SINI7070_008.PRC_TIPO_OCORRENCIA - Problemas ao executar procedure. - ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	end;

	/***********************************************************************************
        prc_cobertura
            Author  : Michael Dossa
            Created : 02/04/2012
            Purpose : Procedure que retorna os tipos de cobertura.
            ***********************************************************************************/
	procedure prc_cobertura(p_id_aviso             in number,
				p_cd_natureza_sinistro in number,
				p_cursor               out tab_prc_cobertura,
				p_mens                 out varchar2) is
		cursor c1 is
			select *
			  from asw0016_aviso_sinst_re_sgrdo asw0016
			 where asw0016.id_aviso_sinst_re_sgrdo = p_id_aviso;
		--
	begin
		--
		for r1 in c1 loop

				open p_cursor for
					select cd_cobertura_basica,
					       cd_cobertura_adicional,
					       cd_cobertura_especial,
					       cd_cobertura_especial_espec,
					       cd_sequencia,
					       ds_cobertura,
					       vl_importancia_segurada
					  from v_sinistro_cobertura
					 where cd_cia_seguradora =
					       global_cd_cia_seguradora
					   and cd_ramo_tmsr =
					       r1.cd_ramo_apoli
					   and cd_apolice_tmsr =
					       r1.cd_apoli
					   and (cd_endosso_tmsr =
					       nvl(r1.cd_endos, 0) or
					       (cd_endosso_tmsr is null and
					       r1.cd_endos is null))
					   and cd_item_apolice_tmsr =
					       r1.cd_item_apoli
					   and id_tipo_endosso_tmsr =
					       r1.cd_tipo_endos
					      -- and    id_sistema_origem        =    2
					   and cd_produto_tmsr =
					       r1.cd_prdut
					   and cd_natureza_sinistro =
					       p_cd_natureza_sinistro;
		end loop;
	exception
		when others then
			p_mens := 'SINI7070_008.PRC_COBERTURA - Problemas ao executar procedure. - ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	end;

	/***********************************************************************************
        prc_tipo_pessoa
            Author  : Michael Dossa
            Created : 02/04/2012
            Purpose : Procedure que retorna os tipos de pessoa.
            ***********************************************************************************/
	procedure prc_tipo_pessoa(p_cursor out tab_prc_tipo_pessoa,
				  p_mens   out varchar2) is
	begin
		open p_cursor for
			select 'F', 'Fsica'
			  from dual
			union
			select 'J', 'Jurdica'
			  from dual;
	exception
		when others then
			p_mens := 'SINI7070_008.PRC_TIPO_PESSOA - Problemas ao executar procedure. - ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	end;
	--
	procedure PRC_IS_PRODUTO_PJ(	P_CD_TIPO_BEM_SEGURADO		IN	NUMBER,
					P_CD_CARACTERISTICA_BEM_SEGUR	IN	NUMBER,
					P_CD_RAMO			IN	NUMBER,
					P_IS_PRODUTO_PJ			OUT	VARCHAR2,
					P_MENS				OUT	VARCHAR2)
	IS
		v_saida_anormal exception;
	BEGIN
		begin
			select
				slrw.ID_PRODUTO_PJ
			into	P_IS_PRODUTO_PJ
			from
				sinistro_liberacao_ramo_web slrw
			where
				slrw.cd_tipo_bem_segurado = P_CD_TIPO_BEM_SEGURADO
			and	slrw.cd_caracteristica_bem_segur = P_CD_CARACTERISTICA_BEM_SEGUR
			and	slrw.cd_ramo = P_CD_RAMO;
		exception
			when no_data_found then
				P_IS_PRODUTO_PJ := 'N';
			when too_many_rows then
				p_mens:= 'Mais de um registro encontrado na SINISTRO_LIBERACAO_RAMO_WEB - Tipo bem: ' || P_CD_TIPO_BEM_SEGURADO
					|| ' carac: ' || P_CD_CARACTERISTICA_BEM_SEGUR || ' ramo: ' || P_CD_RAMO;
			when others then
				p_mens:= 'Falha ao recuperar dados da SINISTRO_LIBERACAO_RAMO_WEB: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
	EXCEPTION
		when v_saida_anormal then
			P_IS_PRODUTO_PJ := 'N';
		when others then
			p_mens:='Erro ao executar PRC_IS_PRODUTO_PJ: ' || p_mens || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	END;
  --=======================================================================================================
  --  PRC_ID_VEICULO -> Retorna o identificador para mostrar ou não o veiculo por Tipo-Carac-Ramo
  --=======================================================================================================
  PROCEDURE PRC_ID_VEICULO( p_cd_tipo_bem_segurado		    in	number,
                            p_cd_caracteristica_bem_segur	in	number,
                            p_cd_ramo			                in	number,
                            p_retorno			                out	varchar2,
                            p_mens				                out	varchar2)
  IS
  BEGIN
    p_retorno := 'N';
    FOR info IN(SELECT  NVL(ID_VEICULO, 'N') ID_VEICULO
                FROM  SINISTRO_LIBERACAO_RAMO_WEB
                WHERE CD_TIPO_BEM_SEGURADO        = p_cd_tipo_bem_segurado
                AND	  CD_CARACTERISTICA_BEM_SEGUR = p_cd_caracteristica_bem_segur
                AND	  CD_RAMO                     = p_cd_ramo)
    LOOP
      p_retorno := info.ID_VEICULO;
    END LOOP;

  EXCEPTION WHEN OTHERS THEN
    p_mens:='Erro ao executar SINI7070_008.PRC_ID_VEICULO: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END PRC_ID_VEICULO;
	--
	procedure prc_busca_causas(	P_CD_TIPO_BEM_SEGURADO		IN	NUMBER,
					P_CD_CARACTERISTICA_BEM_SEGUR	IN	NUMBER,
					P_CD_RAMO			IN	NUMBER,
					P_CD_NATUREZA			IN	NUMBER,
					P_TAB_CAUSAS			OUT	tab_sinistro_causa,
					P_MENS				OUT	VARCHAR2)
	is
		v_saida_anormal exception;
	begin
		begin
			open	P_TAB_CAUSAS	for
				select
					sincausa.cd_causa,
					sincausa.descricao
				from
					sinistro_causa sincausa,
					sinistro_causa_relacao scr
				where
					scr.cd_tipo_bem = P_CD_TIPO_BEM_SEGURADO
				and	scr.cd_caracteristica = P_CD_CARACTERISTICA_BEM_SEGUR
				and	scr.cd_ramo = P_CD_RAMO
				and	scr.cd_natureza = P_CD_NATUREZA
				and	sincausa.cd_causa = scr.cd_causa;
		exception
			when no_data_found then
				p_tab_causas := null;
			when others then
				p_mens := 'Falha ao recuperar lista de causas: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
	exception
		when v_saida_anormal then
			p_mens := 'Erro ao executar prc_busca_causas: ' || p_mens || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
		when others then
			p_mens := 'Erro geral ao executar prc_busca_causas: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	end;
	--
	procedure prc_busca_dados_transporte(	p_cd_ramo_apoli 	in number,
						p_cd_apoli 		in number,
						p_cd_item_apoli 	in number,
						p_tab_asw16 		out tab_asw16,
						p_mens 			out varchar2)	is
	v_saida_anormal exception;
	begin

		begin
			open p_tab_asw16 for
				select
					asw16.id_placa_transportador,
					asw16.id_necessidade_vistoria,
					asw16.cd_tipo_vistoria_sinistro,
					asw16.cd_vistoriador_sinistro,
					asw16.id_necessidade_perito,
					asw16.cd_perito_sinistro,
					asw16.dt_ctrc,
					asw16.vl_embarque,
					asw16.ds_origem,
					asw16.ds_destino
				from asw0016_aviso_sinst_re_sgrdo asw16
				where
					asw16.cd_ramo_apoli = p_cd_ramo_apoli
				and	asw16.cd_apoli = p_cd_apoli
				and	asw16.cd_item_apoli = p_cd_item_apoli ;
		exception
			when no_data_found then
				p_mens := 'Nenhum registro encontrado - Apolice: ' || p_cd_ramo_apoli || p_cd_apoli || ' Item: ' || p_cd_item_apoli;
				raise v_saida_anormal;
			when others then
				p_mens := 'Falha ao recuperar dados da ASW0016: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
	exception
		when v_saida_anormal then
			p_mens := p_mens || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
		when others then
			p_mens := DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	end;

	procedure prc_busca_dados_PJ (		p_cd_aviso		in number,
						p_cd_ramo_apoli 	in number,
						p_cd_apoli 		in number,
						p_cd_item_apoli 	in number,
						p_id_causa		out number,
						p_tab_asw24 		out tab_asw24,
						p_mens 			out varchar2)
	is
		v_saida_anormal exception;
	begin

		begin
			open p_tab_asw24 for
				select
					asw24.cd_fabricante,
					asw24.cd_modelo_veiculo,
					asw24.cd_combustivel,
					asw24.cd_veiculo,
					asw24.cd_ano_veiculo,
					asw24.id_placa
				from	asw0024_aviso_sinst_re_veic asw24
				where
					asw24.cd_ramo_apoli = p_cd_ramo_apoli
				and	asw24.cd_apoli = p_cd_apoli
				and	asw24.cd_item_apoli = p_cd_item_apoli
				and	asw24.cd_reclamacao_elementar = p_cd_aviso
				order by asw24.id_veiculo asc;
		exception
			when no_data_found then
				null;
			when others then
				p_mens := 'Falha ao recuperar dados da ASW0024: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
		--
		begin
			select
				asw16.id_causa
			into	p_id_causa
			from	asw0016_aviso_sinst_re_sgrdo asw16
			where
				asw16.cd_ramo_apoli = p_cd_ramo_apoli
			and	asw16.cd_apoli = p_cd_apoli
			and	asw16.cd_item_apoli = p_cd_item_apoli
			and	asw16.id_aviso_sinst_re_sgrdo = p_cd_aviso;
		exception
			when no_data_found then
				null;
			when others then
				p_mens := 'Falha ao recuperar dados da ASW0016: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;

	exception
		when v_saida_anormal then
			p_mens :=  'Erro ao executar prc_busca_dados_PJ: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
		when others then
			p_mens := DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	end;


	/***********************************************************************************
        prc_inicia_aviso
            Author  : Michael Dossa
            Created : 02/04/2012
            Purpose : Rotina responsavel por gerar novo registro ou retornar o existente.
            ***********************************************************************************/
	procedure prc_inicia_aviso(p_id_aviso_sinst_re_sgrdo in out number,
				   p_cd_cia_sgdra            in out number,
				   p_cd_ramo_apoli           in out number,
				   p_cd_local_apoli          in out number,
				   p_cd_apoli                in out number,
				   p_cd_item_apoli           in out number,
				   p_cd_tipo_endos           in out number,
				   p_cd_endos                in out number,
				   p_cd_prdut                in out number,
				   p_dt_arquv                in out date,
				   p_dt_ocorrencia           in out date,
				   p_cd_tipo_bem_segurado    in out number,
				   p_cd_carac_bem_segurado   in out number,
				   p_cd_ramo_cobertura       in out number,
				   p_id_chave_acsel          in varchar2,
				   p_id_perfil_usuario       in varchar2, --"I"=Interno | "E"=Externo | "C"=Callcenter
				   p_ds_item_apolice         in out varchar2,
				   -- OS 11011
				   p_id_sistema_origem in number,
				   -- OS 228487 -Endesa
				   p_id_matricula in varchar2,
				   -- OS 11011
				   p_dt_inico_vigen              out date,
				   p_dt_termn_vigen              out date,
				   p_cd_crtor                    out number,
				   p_nm_crtor                    out varchar2,
				   p_cd_sgrdo                    out number,
				   p_nm_sgrdo                    out varchar2,
				   p_cd_tipo_sgrdo               out varchar2,
				   p_ds_tipo_sgrdo               out varchar2,
				   p_nr_cpf_cnpj_sgrdo           out number,
				   p_nr_ddd_telef_resdl_sgrdo    out number,
				   p_nr_telef_resdl_sgrdo        out number,
				   p_nr_ddd_telef_comrl_sgrdo    out number,
				   p_nr_telef_comrl_sgrdo        out number,
				   p_nr_ddd_celul_sgrdo          out number,
				   p_nr_telef_celul_sgrdo        out number,
				   p_nm_logra_loc_risco          out varchar2,
				   p_nr_logra_loc_risco          out number,
				   p_ds_cmplo_loc_risco          out varchar2,
				   p_nm_cidad_loc_risco          out varchar2,
				   p_sg_unidd_fedrc_loc_risco    out varchar2,
				   p_cd_comunicante_aviso        out varchar2,
				   p_cd_exite_terc               out varchar2,
				   p_ds_bem_segur                out varchar2,
				   p_nm_comnt                    out varchar2,
				   p_nr_ddd_telef_comrl_comnt    out number,
				   p_nr_telef_comrl_comnt        out number,
				   p_nr_ddd_celul_comnt          out number,
				   p_nr_telef_celul_comnt        out number,
				   p_cd_email_comnt              out varchar2,
				   p_ic_comnt_contt              out varchar2,
				   p_nm_contt                    out varchar2,
				   p_nr_ddd_comrl_contt          out number,
				   p_nr_telef_comrl_contt        out number,
				   p_nr_ddd_celul_contt          out number,
				   p_nr_telef_celul_contt        out number,
				   p_cd_email_contt              out varchar2,
				   p_cd_forma_contt              out varchar2,
				   p_cd_envia_sms_contt          out varchar2,
				   p_cd_num_bo                   out varchar2,
				   p_id_deleg_bo                 out number,
				   p_id_cep_local_sinis          out number,
				   p_nm_logra_loc_sinis          out varchar2,
				   p_nr_logra_loc_sinis          out number,
				   p_ds_complemento_loc_sinis    out varchar2,
				   p_nm_bairro_loc_sinis         out varchar2,
				   p_nm_cidad_loc_sinis          out varchar2,
				   p_sg_unidd_fedrc_loc_sinis    out varchar2,
				   p_ds_descr_sinis              out varchar2,
				   p_id_tipo_ocorr_sinis         out number,
				   p_id_cober_sinis              out number,
				   p_cd_cobertura_basica         out number,
				   p_cd_cobertura_adicional      out number,
				   p_cd_cobertura_especial       out number,
				   p_cd_cobertura_espec_especial out number,
				   p_cd_sequencia_cobertura      out number,
				   p_id_esti_prej_sinis          out number,
				   p_id_faixa_sinis              out number,
				   p_cd_bens_dani_sinis          out varchar2,
				   p_cd_observ_sinis             out varchar2,
				   p_nm_transportadora           out varchar2,
				   p_cd_nota_fiscal              out varchar2,
				   p_cd_chassi                   out varchar2,
				   p_cd_ctrc                     out varchar2,
				   p_ds_produto                  out varchar2,
				   p_id_tipo_operacao            out number,
				   --
				   p_id_cep_sgrdo             out number,
				   p_nm_logra_loc_sgrdo       out varchar2,
				   p_nr_logra_loc_sgrdo       out varchar2,
				   p_nm_bairro_loc_sgrdo      out varchar2,
				   p_nm_cidad_loc_sgrdo       out varchar2,
				   p_sg_unidd_fedrc_loc_sgrdo out varchar2,
				   p_ds_complemento_sgrdo     out varchar2,
				   --
				   p_cd_mesmo_endereco_segurado out varchar2, --endereo da ocorrencia
				   p_cd_autoriza_envio_email    out varchar2,
				   --
				   p_tab_terceiro_re            out tab_terceiro_re,
				   p_cd_benefsinis_assistencia  out number,
				   p_nm_outro_prest_assistencia out varchar2,
				   p_cd_email_prest_assistencia out varchar2,
				   p_vl_qtde_itens_sinist       number,
				   p_mens                       out varchar2,
				   p_idelpol			in	number	default	null,--OS Transporte
				   p_id_tipo_recepcao		in	number	default null --OS PagBank
				   ) is
		v_saida_anormal exception;
		v_acao                        varchar2(1) := null;
		v_retorno                     varchar2(1000) := null;
		v_sessao_asw                  varchar2(30) := null;
		v_ramo_liberado               varchar2(1) := 'N';
		v_nm_segurado                 varchar2(1000) := null;
		v_id_tipo_segurado            varchar2(1) := null;
		v_nr_cgc_cpf_segurado         number := null;
		v_nr_estabelecimento_segurado number := null;
		v_nr_digito_verificador_seg   number := null;
		v_id_email                    varchar2(1000) := null;
		v_nr_ddd                      number := null;
		v_nr_telefone                 number := null;
		v_dt_inicio_vigencia          date := null;
		v_dt_termino_vigencia         date := null;
		v_cd_produto                  number := null;
		v_ds_produto                  varchar2(1000) := null;
		v_cd_corretor                 number := null;
		v_cd_tipo_corretor            varchar2(1000) := null;
		v_cd_cgc_cpf_corretor         number := null;
		v_cd_estabelecimento_corretor number := null;
		v_nr_digito_verificador_corr  number := null;
		v_nm_razao_social             varchar2(1000) := null;
		v_ds_tipo_pessoa              varchar2(1000) := null;
		v_existe_terc                 number := 0;
		v_lock                        varchar2(1000) := null;
		--
		v_cd_tipo_bem_segurado		number;
		v_cd_caracteristica_bem_segur	number;
		v_cd_ramo_cobertura		number;
		-- mundaca 0300 para 0800
		v_tel_CC			varchar2(100);
	begin
		begin
			select	ds_valor
			into	v_tel_CC
			from	wf_config
			where 	cd_config='frase.telefone.tokio.email';
		exception
			when	others	then
				v_tel_CC	:=	null;
		end;
		--

		begin
			prc_verifica_insert_update(p_cd_cia_sgdra,
						   p_cd_ramo_apoli,
						   p_cd_local_apoli,
						   p_cd_apoli,
						   p_cd_item_apoli,
						   --p_cd_tipo_endos                 ,
						   --p_cd_endos                      ,
						   p_cd_prdut,
						   p_dt_ocorrencia,
						   v_acao,
						   p_id_aviso_sinst_re_sgrdo,
						   p_mens);
		exception
			when others then
				p_mens := 'Problemas ao chamar procedure PRC_VERIFICA_INSERT_UPDATE - ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
		if p_id_perfil_usuario is null then
			p_mens := 'Perfil de usurio não informado';
			raise v_saida_anormal;
		end if;
		--
		if p_cd_tipo_bem_segurado = 1 then
			p_mens := 'Ramo de automvel. Favor realizar a abertura pela tela de aviso de sinistro de automvel.';
			raise v_saida_anormal;
		elsif p_cd_tipo_bem_segurado = 3 then
			p_mens := 'Ramo de vida. Favor realizar a abertura pela tela de aviso de sinistro de vida.';
			raise v_saida_anormal;
		end if;
		--
		if	p_idelpol	is	null	then
			--
			begin
				select p.ds_produto
				  into p_ds_produto
				  from sin_produto p
				 where p.cd_produto = p_cd_prdut;
			exception
				when others then
					p_mens := 'TMS - Erro ao tentar localizar produto ' ||
						  p_cd_prdut || ' - Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			--
			begin
				p_id_tipo_operacao := sini7070_007.fnc_recupera_tipo_operacao(p_cd_tipo_bem_segurado,
											      p_cd_carac_bem_segurado,
											      p_cd_ramo_cobertura,
											      p_mens);
			exception
				when others then
					p_mens := 'Problemas na chamada da rotina SINI7070_007.FNC_RECUPERA_TIPO_OPERACAO. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			if p_mens is not null then
				raise v_saida_anormal;
			end if;
			--
			begin
				v_ramo_liberado := fnc_verifica_ramo_asw(p_cd_tipo_bem_segurado,
									 --p_cd_tipo_bem_segurado  in              number,
									 p_cd_carac_bem_segurado,
									 -- p_cd_caract_bem_segur   in              number,
									 p_cd_ramo_cobertura,
									 --p_cd_ramo               in              number,
									 p_id_perfil_usuario,
									 --p_id_perfil             in              varchar2,
									 p_mens
									 --p_mens                          out     varchar2
									 );
			exception
				when others then
					p_mens := 'Problemas na chamada da rotina FNC_VERIFICA_RAMO_ASW. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			if p_mens is not null then
				raise v_saida_anormal;
			end if;
			if v_ramo_liberado = 'N' then
				p_mens := 'Abertura de sinistro On-line não disponvel para este produto. ' ||
				'Favor entre em contato com a Central de Atendimento pelo telefone ' || v_tel_CC;
				raise v_saida_anormal;
			end if;
			--
		end	if;
		--
		if v_acao = 'I' then
			--
			if p_cd_cia_sgdra = global_cd_cia_seguradora then
				if p_id_sistema_origem in (2,3) then
					begin
						v_sessao_asw := sini4210_017.fnc_retorna_sessao_web;
					exception
						when others then
							p_mens := 'Problemas ao executar Função FNC_RETORNA_SESSAO_WEB - Erro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
					--

					if	p_idelpol	is	null	then
						--
						begin
							select sba.cd_endosso_tmsr,
							       sba.cd_tipo_endosso_tmsr
							  into p_cd_endos,
							       p_cd_tipo_endos
							  from sinistro_busca_apolice sba
							 where sba.id_chave_acselx =
							       p_id_chave_acsel
							   and rownum < 2;
						exception
							when others then
								p_mens := 'Problemas ao tentar recuperar endosso. Erro: ' ||
									  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;
						end;
						--
						begin
							select sba.id_chave_acselx
							  into v_lock
							  from sinistro_busca_apolice sba
							 where sba.id_chave_acselx =
							       p_id_chave_acsel
							   for update nowait;
						exception
							when others then
								if sqlcode = 54 then
									v_lock := 'S';
								end if;
						end;
						if v_lock <> 'S' then
							begin
								delete sinistro_busca_apolice sba
								 where sba.id_chave_acselx =
								       p_id_chave_acsel;
							exception
								when others then
									p_mens := 'Problemas ao tentar limpar dados chave acsel. Erro: ' ||
										  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
									raise v_saida_anormal;
							end;
						end if;
						commit;
						--
					else
						-- OS-45912 - Incluindo na consulta a seguir a informação do endosso, pois ele é passado por
						-- parâmetro, e buscando apenas pelo idepol isso pode retornar a informação errada.
						if	p_cd_endos	is not null then
						      begin
								select	sba.cd_endosso_tmsr,
									sba.cd_tipo_endosso_tmsr
								into	p_cd_endos,
									p_cd_tipo_endos
								from	sinistro_busca_apolice	sba
								where	sba.idepol		=	p_idelpol
								and	sba.cd_endosso_tmsr	=	p_cd_endos
								and	rownum			<	2;
						      exception
							      when others then
								      p_mens := 'Problemas ao tentar recuperar endosso, passando o endosso. Erro: ' ||
										DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								      raise v_saida_anormal;
						      end;
						else
							begin
								select	sba.cd_endosso_tmsr,
									sba.cd_tipo_endosso_tmsr
								into	p_cd_endos,
									p_cd_tipo_endos
								from	sinistro_busca_apolice sba
								where	sba.idepol	=	p_idelpol
								and	rownum		<	2;
							exception
								when others then
									p_mens := 'Problemas ao tentar recuperar endosso. Erro: ' ||
									DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
									raise v_saida_anormal;
							end;
						end if;
						--
						begin
							select sba.id_chave_acselx
							  into v_lock
							  from sinistro_busca_apolice sba
							 where sba.idepol = p_idelpol
							   for update nowait;
						exception
							when others then
								if sqlcode = 54 then
									v_lock := 'S';
								end if;
						end;
						if v_lock <> 'S' then
							begin
								delete sinistro_busca_apolice sba
								 where sba.idepol = p_idelpol;
							exception
								when others then
									p_mens := 'Problemas ao tentar limpar dados chave acsel. Erro: ' ||
										  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
									raise v_saida_anormal;
							end;
						end if;
						commit;
						--
						--
					end	if;
					--
					--carrega aplice
					begin
						v_retorno := sini8050_002.carrega_segurado(v_sessao_asw,
											   -- p_id_sessao
											   p_id_chave_acsel,
											   -- p_id_chave_acselx
											   p_idelpol,--OS Transporte
											   p_dt_ocorrencia--OS Transporte
											   );
					exception
						when others then
							p_mens := 'Problemas ao tentar carregar aplice TMSR. Erro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					end;
					--
					if v_retorno is not null then
						p_mens := v_retorno;
						raise v_saida_anormal;
					end if;
					-- OS 11011
					if	p_idelpol	is	not	null	then
						--
						begin
							--
							select	a.cd_produto,
								b.ds_produto,
								a.cd_tipo_bem_segurado,
								a.cd_caracteristica_bem_segur,
								a.cd_ramo_cobertura,
								a.cd_tipo_endosso
							into	p_cd_prdut,
								p_ds_produto,
								v_cd_tipo_bem_segurado,
								v_cd_caracteristica_bem_segur,
								v_cd_ramo_cobertura,
								p_cd_tipo_endos
							from	sin_apolice_item_ramo	a,
								sin_produto	b
							where	a.cd_produto			=	b.cd_produto
							and	a.cd_companhia_segur_emissao	=	p_cd_cia_sgdra
							and	a.cd_ramo_produto		=	p_cd_ramo_apoli
							and	a.cd_apolice			=	p_cd_apoli
							and	a.cd_endosso			=	p_cd_endos
							and	a.cd_item_apolice		=	p_cd_item_apoli;
							--
						exception
							when	others	then
								--
								p_mens	:=	'Problemas ao tentar recuperar dados da apólice. Erro: ' ||
									  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise	v_saida_anormal;
								--
						end;
						--
						begin
							p_id_tipo_operacao := sini7070_007.fnc_recupera_tipo_operacao(v_cd_tipo_bem_segurado,
														      v_cd_caracteristica_bem_segur,
														      v_cd_ramo_cobertura,
														      p_mens);
						exception
							when others then
								p_mens := 'Problemas na chamada da rotina SINI7070_007.FNC_RECUPERA_TIPO_OPERACAO. Erro: ' ||
									  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;
						end;
						if p_mens is not null then
							raise v_saida_anormal;
						end if;
						--
						begin
							v_ramo_liberado := fnc_verifica_ramo_asw(v_cd_tipo_bem_segurado,
												 --p_cd_tipo_bem_segurado  in              number,
												 v_cd_caracteristica_bem_segur,
												 -- p_cd_caract_bem_segur   in              number,
												 v_cd_ramo_cobertura,
												 --p_cd_ramo               in              number,
												 p_id_perfil_usuario,
												 --p_id_perfil             in              varchar2,
												 p_mens
												 --p_mens                          out     varchar2
												 );
						exception
							when others then
								p_mens := 'Problemas na chamada da rotina FNC_VERIFICA_RAMO_ASW. Erro: ' ||
									  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;
						end;
						if p_mens is not null then
							raise v_saida_anormal;
						end if;
						if v_ramo_liberado = 'N' then
							p_mens := 'Abertura de sinistro On-line não disponvel para este produto. ' ||
							' Favor entre em contato com a Central de Atendimento pelo telefone ' || v_tel_CC;
							raise v_saida_anormal;
						end if;
						--
						p_cd_tipo_bem_segurado	:=	v_cd_tipo_bem_segurado;
						p_cd_carac_bem_segurado	:=	v_cd_caracteristica_bem_segur;
						p_cd_ramo_cobertura	:=	v_cd_ramo_cobertura;
						--
					end	if;
					--
				elsif p_id_sistema_origem = 1 then
					begin
						prod4100_073.prc_carrega_apolice(p_id_chave_acsel,
										 p_mens);
					exception
						when others then
							p_mens := 'Erro ao tentar chamar PROD4100_073.PRC_CARREGA_APOLICE. Erro - ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
					if p_mens is not null then
						raise v_saida_anormal;
					end if;
				end if;
				-- OS 11011
				--dados da aplice
				if p_cd_tipo_bem_segurado = 2 then
					--imvel
					begin
						select sa.cd_segurado,
						       ss.nm_segurado,
						       ss.id_tipo_segurado,
						       ss.nr_cgc_cpf_segurado,
						       ss.nr_estabelecimento_segurado,
						       ss.nr_digito_verificador,
						       ss.id_email,
						       ss.nr_ddd,
						       ss.nr_telefone,
						       nvl(said.dt_alteracao,
							   said.dt_inicio_vigencia),
						       said.dt_termino_vigencia,
						       sa.cd_produto,
						       sp.ds_produto,
						       sa.cd_corretor,
						       sc.cd_tipo_corretor,
						       sc.cd_cgc_cpf_corretor,
						       sc.cd_estabelecimento_corretor,
						       sc.nr_digito_verificador,
						       sc.nm_razao_social
						  into p_cd_sgrdo,
						       v_nm_segurado,
						       v_id_tipo_segurado,
						       v_nr_cgc_cpf_segurado,
						       v_nr_estabelecimento_segurado,
						       v_nr_digito_verificador_seg,
						       v_id_email,
						       v_nr_ddd,
						       v_nr_telefone,
						       v_dt_inicio_vigencia,
						       v_dt_termino_vigencia,
						       v_cd_produto,
						       v_ds_produto,
						       v_cd_corretor,
						       v_cd_tipo_corretor,
						       v_cd_cgc_cpf_corretor,
						       v_cd_estabelecimento_corretor,
						       v_nr_digito_verificador_corr,
						       v_nm_razao_social
						  from sin_apolice             sa,
						       sin_apolice_item_imovel said,
						       sin_segurado            ss,
						       sin_produto             sp,
						       sin_corretor            sc,
						       sin_corretor_divisao    scd
						 where sa.cd_companhia_segur_emissao =
						       said.cd_companhia_segur_emissao
						   and sa.cd_ramo_produto =
						       said.cd_ramo_produto
						   and sa.cd_apolice =
						       said.cd_apolice
						   and sa.cd_endosso =
						       said.cd_endosso
						   and sa.cd_tipo_endosso =
						       said.cd_tipo_endosso
						   and sa.cd_segurado =
						       ss.cd_segurado
						   and sa.cd_sistema_origem =
						       ss.cd_sistema_origem
						   and said.cd_companhia_segur_emissao =
						       p_cd_cia_sgdra
						   and said.cd_ramo_produto =
						       p_cd_ramo_apoli
						   and said.cd_apolice =
						       p_cd_apoli
						   and said.cd_endosso =
						       p_cd_endos
						   and said.cd_tipo_endosso =
						       p_cd_tipo_endos
						   and said.cd_item_apolice =
						       p_cd_item_apoli
						   and sa.cd_produto =
						       sp.cd_produto
						   and sa.cd_corretor =
						       scd.cd_corretor
						   and sc.cd_tipo_corretor =
						       scd.cd_tipo_corretor
						   and sc.cd_cgc_cpf_corretor =
						       scd.cd_cgc_cpf_corretor
						   and sc.cd_estabelecimento_corretor =
						       scd.cd_estabelecimento_corretor;
					exception
						when others then
							p_mens := 'SAII - Problemas ao encontrar dados da aplice ' ||
								  p_cd_cia_sgdra || ' ' ||
								  p_cd_ramo_apoli || ' ' ||
								  p_cd_apoli || ' ' ||
								  p_cd_tipo_endos || ' ' ||
								  p_cd_endos || ' ' ||
								  p_cd_item_apoli ||
								  '. Erro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
				elsif p_cd_tipo_bem_segurado = 4 then
					--Riscos Diversos
					begin
						select sa.cd_segurado,
						       ss.nm_segurado,
						       ss.id_tipo_segurado,
						       ss.nr_cgc_cpf_segurado,
						       ss.nr_estabelecimento_segurado,
						       ss.nr_digito_verificador,
						       ss.id_email,
						       ss.nr_ddd,
						       ss.nr_telefone,
						       nvl(said.dt_alteracao,
							   said.dt_inicio_vigencia),
						       said.dt_termino_vigencia,
						       sa.cd_produto,
						       sp.ds_produto,
						       sa.cd_corretor,
						       sc.cd_tipo_corretor,
						       sc.cd_cgc_cpf_corretor,
						       sc.cd_estabelecimento_corretor,
						       sc.nr_digito_verificador,
						       sc.nm_razao_social
						  into p_cd_sgrdo,
						       v_nm_segurado,
						       v_id_tipo_segurado,
						       v_nr_cgc_cpf_segurado,
						       v_nr_estabelecimento_segurado,
						       v_nr_digito_verificador_seg,
						       v_id_email,
						       v_nr_ddd,
						       v_nr_telefone,
						       v_dt_inicio_vigencia,
						       v_dt_termino_vigencia,
						       v_cd_produto,
						       v_ds_produto,
						       v_cd_corretor,
						       v_cd_tipo_corretor,
						       v_cd_cgc_cpf_corretor,
						       v_cd_estabelecimento_corretor,
						       v_nr_digito_verificador_corr,
						       v_nm_razao_social
						  from sin_apolice                  sa,
						       sin_apolice_item_risco_diver said,
						       sin_segurado                 ss,
						       sin_produto                  sp,
						       sin_corretor                 sc,
						       sin_corretor_divisao         scd
						 where sa.cd_companhia_segur_emissao =
						       said.cd_companhia_segur_emissao
						   and sa.cd_ramo_produto =
						       said.cd_ramo_produto
						   and sa.cd_apolice =
						       said.cd_apolice
						   and sa.cd_endosso =
						       said.cd_endosso
						   and sa.cd_tipo_endosso =
						       said.cd_tipo_endosso
						   and sa.cd_segurado =
						       ss.cd_segurado
						   and sa.cd_sistema_origem =
						       ss.cd_sistema_origem
						   and said.cd_companhia_segur_emissao =
						       p_cd_cia_sgdra
						   and said.cd_ramo_produto =
						       p_cd_ramo_apoli
						   and said.cd_apolice =
						       p_cd_apoli
						   and said.cd_endosso =
						       p_cd_endos
						   and said.cd_tipo_endosso =
						       p_cd_tipo_endos
						   and said.cd_item_apolice =
						       p_cd_item_apoli
						   and sa.cd_produto =
						       sp.cd_produto
						   and sa.cd_corretor =
						       scd.cd_corretor
						   and sc.cd_tipo_corretor =
						       scd.cd_tipo_corretor
						   and sc.cd_cgc_cpf_corretor =
						       scd.cd_cgc_cpf_corretor
						   and sc.cd_estabelecimento_corretor =
						       scd.cd_estabelecimento_corretor;
					exception
						when others then
							p_mens := 'SAIRD - Problemas ao encontrar dados da aplice ' ||
								  p_cd_cia_sgdra || ' ' ||
								  p_cd_ramo_apoli || ' ' ||
								  p_cd_apoli || ' ' ||
								  p_cd_tipo_endos || ' ' ||
								  p_cd_endos || ' ' ||
								  p_cd_item_apoli ||
								  '. Erro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
				elsif p_cd_tipo_bem_segurado = 5 then
					--Demais
					begin
						select sa.cd_segurado,
						       ss.nm_segurado,
						       ss.id_tipo_segurado,
						       ss.nr_cgc_cpf_segurado,
						       ss.nr_estabelecimento_segurado,
						       ss.nr_digito_verificador,
						       ss.id_email,
						       ss.nr_ddd,
						       ss.nr_telefone,
						       nvl(said.dt_alteracao,
							   said.dt_inicio_vigencia),
						       said.dt_termino_vigencia,
						       sa.cd_produto,
						       sp.ds_produto,
						       sa.cd_corretor,
						       sc.cd_tipo_corretor,
						       sc.cd_cgc_cpf_corretor,
						       sc.cd_estabelecimento_corretor,
						       sc.nr_digito_verificador,
						       sc.nm_razao_social
						  into p_cd_sgrdo,
						       v_nm_segurado,
						       v_id_tipo_segurado,
						       v_nr_cgc_cpf_segurado,
						       v_nr_estabelecimento_segurado,
						       v_nr_digito_verificador_seg,
						       v_id_email,
						       v_nr_ddd,
						       v_nr_telefone,
						       v_dt_inicio_vigencia,
						       v_dt_termino_vigencia,
						       v_cd_produto,
						       v_ds_produto,
						       v_cd_corretor,
						       v_cd_tipo_corretor,
						       v_cd_cgc_cpf_corretor,
						       v_cd_estabelecimento_corretor,
						       v_nr_digito_verificador_corr,
						       v_nm_razao_social
						  from sin_apolice             sa,
						       sin_apolice_item_demais said,
						       sin_segurado            ss,
						       sin_produto             sp,
						       sin_corretor            sc,
						       sin_corretor_divisao    scd
						 where sa.cd_companhia_segur_emissao =
						       said.cd_companhia_segur_emissao
						   and sa.cd_ramo_produto =
						       said.cd_ramo_produto
						   and sa.cd_apolice =
						       said.cd_apolice
						   and sa.cd_endosso =
						       said.cd_endosso
						   and sa.cd_tipo_endosso =
						       said.cd_tipo_endosso
						   and sa.cd_segurado =
						       ss.cd_segurado
						   and sa.cd_sistema_origem =
						       ss.cd_sistema_origem
						   and said.cd_companhia_segur_emissao =
						       p_cd_cia_sgdra
						   and said.cd_ramo_produto =
						       p_cd_ramo_apoli
						   and said.cd_apolice =
						       p_cd_apoli
						   and said.cd_endosso =
						       p_cd_endos
						   and said.cd_tipo_endosso =
						       p_cd_tipo_endos
						   and said.cd_item_apolice =
						       p_cd_item_apoli
						   and sa.cd_produto =
						       sp.cd_produto
						   and sa.cd_corretor =
						       scd.cd_corretor
						   and sc.cd_tipo_corretor =
						       scd.cd_tipo_corretor
						   and sc.cd_cgc_cpf_corretor =
						       scd.cd_cgc_cpf_corretor
						   and sc.cd_estabelecimento_corretor =
						       scd.cd_estabelecimento_corretor;
					exception
						when others then
							p_mens := 'SAID - Problemas ao encontrar dados da aplice ' ||
								  p_cd_cia_sgdra || ' ' ||
								  p_cd_ramo_apoli || ' ' ||
								  p_cd_apoli || ' ' ||
								  p_cd_tipo_endos || ' ' ||
								  p_cd_endos || ' ' ||
								  p_cd_item_apoli ||
								  '. Erro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
				else
					p_mens := 'X - Tipo de bem segurado ' ||
						  p_cd_tipo_bem_segurado ||
						  ' não enquadrado neste processo.';
					raise v_saida_anormal;
				end if;
			else
				p_mens := 'Companhia ' ||
					  nvl(p_cd_cia_sgdra, 'NULL') ||
					  ' inválida.';
				raise v_saida_anormal;
			end if;
			--
			if v_id_tipo_segurado = 'F' then
				v_ds_tipo_pessoa    := 'PESSOA FISICA';
				p_nr_cpf_cnpj_sgrdo := v_nr_cgc_cpf_segurado ||
						       lpad(v_nr_digito_verificador_seg,
							    2,
							    0);
			else
				v_ds_tipo_pessoa    := 'PESSOA JURIDICA';
				p_nr_cpf_cnpj_sgrdo := v_nr_cgc_cpf_segurado ||
						       lpad(v_nr_estabelecimento_segurado,
							    4,
							    0) ||
						       lpad(v_nr_digito_verificador_seg,
							    2,
							    0);
			end if;
			--
			begin
				prc_insere_asw0016(p_id_aviso_sinst_re_sgrdo,
						   p_cd_cia_sgdra,
						   p_cd_ramo_apoli,
						   p_cd_local_apoli,
						   p_cd_apoli,
						   p_cd_item_apoli,
						   p_cd_tipo_endos,
						   p_cd_endos,
						   p_cd_prdut,
						   p_dt_arquv,
						   p_dt_ocorrencia,
						   v_dt_inicio_vigencia,
						   --p_dt_inico_vigen               ,
						   v_dt_termino_vigencia,
						   --p_dt_termn_vigen               ,
						   p_cd_tipo_bem_segurado,
						   p_cd_carac_bem_segurado,
						   p_cd_ramo_cobertura,
						   v_cd_corretor,
						   --p_cd_crtor                     ,
						   v_nm_razao_social,
						   --p_nm_crtor                     ,
						   p_cd_sgrdo,
						   --p_cd_sgrdo                     ,
						   v_nm_segurado,
						   --p_nm_sgrdo                     ,
						   v_id_tipo_segurado,
						   --p_cd_tipo_sgrdo                ,
						   v_ds_tipo_pessoa,
						   --p_ds_tipo_sgrdo                ,
						   p_nr_cpf_cnpj_sgrdo,
						   p_nr_ddd_telef_resdl_sgrdo,
						   p_nr_telef_resdl_sgrdo,
						   p_nr_ddd_telef_comrl_sgrdo,
						   p_nr_telef_comrl_sgrdo,
						   p_nr_ddd_celul_sgrdo,
						   p_nr_telef_celul_sgrdo,
						   p_nm_logra_loc_risco,
						   p_nr_logra_loc_risco,
						   p_ds_cmplo_loc_risco,
						   p_nm_cidad_loc_risco,
						   p_sg_unidd_fedrc_loc_risco,
						   p_cd_comunicante_aviso,
						   p_cd_exite_terc,
						   p_ds_item_apolice,
						   p_nm_comnt,
						   p_nr_ddd_telef_comrl_comnt,
						   p_nr_telef_comrl_comnt,
						   p_nr_ddd_celul_comnt,
						   p_nr_telef_celul_comnt,
						   p_cd_email_comnt,
						   p_ic_comnt_contt,
						   p_nm_contt,
						   p_nr_ddd_comrl_contt,
						   p_nr_telef_comrl_contt,
						   p_nr_ddd_celul_contt,
						   p_nr_telef_celul_contt,
						   p_cd_email_contt,
						   p_cd_forma_contt,
						   p_cd_envia_sms_contt,
						   p_cd_num_bo,
						   p_id_deleg_bo,
						   p_id_cep_local_sinis,
						   p_nm_logra_loc_sinis,
						   p_nr_logra_loc_sinis,
						   p_nm_bairro_loc_sinis,
						   p_nm_cidad_loc_sinis,
						   p_sg_unidd_fedrc_loc_sinis,
						   p_ds_descr_sinis,
						   p_id_tipo_ocorr_sinis,
						   p_id_cober_sinis,
						   p_id_esti_prej_sinis,
						   p_id_faixa_sinis,
						   p_cd_bens_dani_sinis,
						   p_cd_observ_sinis,
						   p_nm_transportadora,
						   p_cd_nota_fiscal,
						   p_cd_chassi,
						   p_cd_ctrc,
						   p_id_perfil_usuario,
						   p_id_matricula, --Endesa
						   p_vl_qtde_itens_sinist,
						   p_mens,
						   null,	      --OS PagBank
						   p_id_tipo_recepcao --OS PagBank
						   );
			exception
				when others then
					p_mens := 'Problemas na chamada da PRC_INSERE_ASW0016 - ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			--carrega dados iniciais.
			begin
				prc_carrega_aviso_parcial(p_id_aviso_sinst_re_sgrdo,
							  p_cd_cia_sgdra,
							  p_cd_ramo_apoli,
							  p_cd_local_apoli,
							  p_cd_apoli,
							  p_cd_item_apoli,
							  p_cd_tipo_endos,
							  p_cd_endos,
							  p_cd_prdut,
							  p_dt_arquv,
							  p_dt_ocorrencia,
							  p_dt_inico_vigen,
							  p_dt_termn_vigen,
							  p_cd_ramo_cobertura,
							  p_cd_crtor,
							  p_nm_crtor,
							  p_cd_sgrdo,
							  p_nm_sgrdo,
							  p_cd_tipo_sgrdo,
							  p_ds_tipo_sgrdo,
							  p_nr_cpf_cnpj_sgrdo,
							  p_nr_ddd_telef_resdl_sgrdo,
							  p_nr_telef_resdl_sgrdo,
							  p_nr_ddd_telef_comrl_sgrdo,
							  p_nr_telef_comrl_sgrdo,
							  p_nr_ddd_celul_sgrdo,
							  p_nr_telef_celul_sgrdo,
							  p_nm_logra_loc_risco,
							  p_nr_logra_loc_risco,
							  p_ds_cmplo_loc_risco,
							  p_nm_cidad_loc_risco,
							  p_sg_unidd_fedrc_loc_risco,
							  p_cd_comunicante_aviso,
							  p_cd_exite_terc,
							  p_nm_comnt,
							  p_nr_ddd_telef_comrl_comnt,
							  p_nr_telef_comrl_comnt,
							  p_nr_ddd_celul_comnt,
							  p_nr_telef_celul_comnt,
							  p_cd_email_comnt,
							  p_ic_comnt_contt,
							  p_nm_contt,
							  p_nr_ddd_comrl_contt,
							  p_nr_telef_comrl_contt,
							  p_nr_ddd_celul_contt,
							  p_nr_telef_celul_contt,
							  p_cd_email_contt,
							  p_cd_forma_contt,
							  p_cd_envia_sms_contt,
							  p_cd_num_bo,
							  p_id_deleg_bo,
							  p_id_cep_local_sinis,
							  p_nm_logra_loc_sinis,
							  p_nr_logra_loc_sinis,
							  p_ds_complemento_loc_sinis,
							  p_nm_bairro_loc_sinis,
							  p_nm_cidad_loc_sinis,
							  p_sg_unidd_fedrc_loc_sinis,
							  p_ds_descr_sinis,
							  p_id_tipo_ocorr_sinis,
							  p_id_cober_sinis,
							  p_id_esti_prej_sinis,
							  p_id_faixa_sinis,
							  p_cd_bens_dani_sinis,
							  p_cd_observ_sinis,
							  p_nm_transportadora,
							  p_cd_nota_fiscal,
							  p_cd_chassi,
							  p_cd_ctrc,
							  p_cd_cobertura_basica,
							  p_cd_cobertura_adicional,
							  p_cd_cobertura_especial,
							  p_cd_cobertura_espec_especial,
							  p_cd_sequencia_cobertura,
							  p_ds_item_apolice,
							  p_cd_autoriza_envio_email,
							  p_cd_benefsinis_assistencia,
							  p_nm_outro_prest_assistencia,
							  p_cd_email_prest_assistencia,
							  p_mens);
			exception
				when others then
					p_mens := 'I - Problemas ao chamar PRC_CARREGA_AVISO_PARCIAL - ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			if p_mens is not null then
				raise v_saida_anormal;
			end if;
			p_ds_bem_segur := null;
			--carrega cursor nulo
			open p_tab_terceiro_re for
				select null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null
				  from dual;
		else
			begin
				prc_carrega_aviso_parcial(p_id_aviso_sinst_re_sgrdo,
							  p_cd_cia_sgdra,
							  p_cd_ramo_apoli,
							  p_cd_local_apoli,
							  p_cd_apoli,
							  p_cd_item_apoli,
							  p_cd_tipo_endos,
							  p_cd_endos,
							  p_cd_prdut,
							  p_dt_arquv,
							  p_dt_ocorrencia,
							  p_dt_inico_vigen,
							  p_dt_termn_vigen,
							  p_cd_ramo_cobertura,
							  p_cd_crtor,
							  p_nm_crtor,
							  p_cd_sgrdo,
							  p_nm_sgrdo,
							  p_cd_tipo_sgrdo,
							  p_ds_tipo_sgrdo,
							  p_nr_cpf_cnpj_sgrdo,
							  p_nr_ddd_telef_resdl_sgrdo,
							  p_nr_telef_resdl_sgrdo,
							  p_nr_ddd_telef_comrl_sgrdo,
							  p_nr_telef_comrl_sgrdo,
							  p_nr_ddd_celul_sgrdo,
							  p_nr_telef_celul_sgrdo,
							  p_nm_logra_loc_risco,
							  p_nr_logra_loc_risco,
							  p_ds_cmplo_loc_risco,
							  p_nm_cidad_loc_risco,
							  p_sg_unidd_fedrc_loc_risco,
							  p_cd_comunicante_aviso,
							  p_cd_exite_terc,
							  p_nm_comnt,
							  p_nr_ddd_telef_comrl_comnt,
							  p_nr_telef_comrl_comnt,
							  p_nr_ddd_celul_comnt,
							  p_nr_telef_celul_comnt,
							  p_cd_email_comnt,
							  p_ic_comnt_contt,
							  p_nm_contt,
							  p_nr_ddd_comrl_contt,
							  p_nr_telef_comrl_contt,
							  p_nr_ddd_celul_contt,
							  p_nr_telef_celul_contt,
							  p_cd_email_contt,
							  p_cd_forma_contt,
							  p_cd_envia_sms_contt,
							  p_cd_num_bo,
							  p_id_deleg_bo,
							  p_id_cep_local_sinis,
							  p_nm_logra_loc_sinis,
							  p_nr_logra_loc_sinis,
							  p_ds_complemento_loc_sinis,
							  p_nm_bairro_loc_sinis,
							  p_nm_cidad_loc_sinis,
							  p_sg_unidd_fedrc_loc_sinis,
							  p_ds_descr_sinis,
							  p_id_tipo_ocorr_sinis,
							  p_id_cober_sinis,
							  p_id_esti_prej_sinis,
							  p_id_faixa_sinis,
							  p_cd_bens_dani_sinis,
							  p_cd_observ_sinis,
							  p_nm_transportadora,
							  p_cd_nota_fiscal,
							  p_cd_chassi,
							  p_cd_ctrc,
							  p_cd_cobertura_basica,
							  p_cd_cobertura_adicional,
							  p_cd_cobertura_especial,
							  p_cd_cobertura_espec_especial,
							  p_cd_sequencia_cobertura,
							  p_ds_item_apolice,
							  p_cd_autoriza_envio_email,
							  p_cd_benefsinis_assistencia,
							  p_nm_outro_prest_assistencia,
							  p_cd_email_prest_assistencia,
							  p_mens);
			exception
				when others then
					p_mens := 'U - Problemas ao chamar PRC_CARREGA_AVISO_PARCIAL - ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			if p_mens is not null then
				raise v_saida_anormal;
			end if;

			if	p_idelpol	is	not	null	then
				--
				begin
					--
					select	a.cd_tipo_bem_segurado,
						a.cd_caracteristica_bem_segur,
						a.cd_ramo_cobertura,
						a.cd_tipo_endosso
					into	p_cd_tipo_bem_segurado,
						p_cd_carac_bem_segurado,
						p_cd_ramo_cobertura,
						p_cd_tipo_endos
					from	sin_apolice_item_ramo	a,
						sin_produto	b
					where	a.cd_produto			=	b.cd_produto
					and	a.cd_companhia_segur_emissao	=	p_cd_cia_sgdra
					and	a.cd_ramo_produto		=	p_cd_ramo_apoli
					and	a.cd_apolice			=	p_cd_apoli
					and	a.cd_item_apolice		=	p_cd_item_apoli;
					--
				exception
					when	others	then
						--
						p_mens	:=	'Problemas ao tentar recuperar dados da apólice. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise	v_saida_anormal;
						--
				end;
				--
			end	if;

			--carrega lista de terceiros
			v_existe_terc := 0;
			begin
				select count(1)
				  into v_existe_terc
				  from asw0017_terceiro_re asw0017
				 where asw0017.id_aviso_sinst_re_sgrdo =
				       p_id_aviso_sinst_re_sgrdo;
			exception
				when others then
					p_mens := 'Problemas ao verificar se existem terceiros. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			if v_existe_terc > 0 then
				begin
					open p_tab_terceiro_re for
						select asw0017.id_terceiro_re,
						       asw0017.id_tipo_pessoa_terc,
						       asw0017.nr_cpf_cnpj_terc,
						       asw0017.nm_terceiro,
						       asw0017.id_cep_ocorrencia,
						       asw0017.ds_local_ocorrencia,
						       asw0017.nr_local_ocorrencia,
						       asw0017.nm_bairro_ocorrencia,
						       asw0017.nm_municipio_ocorrencia,
						       asw0017.id_unidade_federacao_ocorr,
						       asw0017.nr_ddd_contato,
						       asw0017.nr_telefone_contato,
						       asw0017.nr_ddd_cel_terceiro,
						       asw0017.nr_tel_cel_terceiro,
						       asw0017.id_email_terceiro,
						       asw0017.ds_bens
						  from asw0017_terceiro_re asw0017
						 where asw0017.id_aviso_sinst_re_sgrdo =
						       p_id_aviso_sinst_re_sgrdo;
				exception
					when others then
						p_mens := 'Problemas ao tentar carregar lista de terceiros vinculados ao aviso ' ||
							  p_id_aviso_sinst_re_sgrdo ||
							  '. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
			else
				open p_tab_terceiro_re for
					select null,
					       null,
					       null,
					       null,
					       null,
					       null,
					       null,
					       null,
					       null,
					       null,
					       null,
					       null,
					       null,
					       null,
					       null,
					       null
					  from dual;
			end if;
			--endereo do segurado
			if p_cd_cia_sgdra = global_cd_cia_seguradora then
				begin
					select se.id_cep,
					       se.ds_endereco,
					       replace(se.nr_endereco,
						       ' ',
						       ''),
					       se.nm_bairro,
					       se.nm_municipio,
					       se.id_unidade_federacao,
					       se.nm_complemento_endereco
					  into p_id_cep_sgrdo,
					       p_nm_logra_loc_sgrdo,
					       p_nr_logra_loc_sgrdo,
					       p_nm_bairro_loc_sgrdo,
					       p_nm_cidad_loc_sgrdo,
					       p_sg_unidd_fedrc_loc_sgrdo,
					       p_ds_complemento_sgrdo
					  from sin_segurado_endereco se,
					       sin_apolice           sa
					 where se.cd_endereco_segurado =
					       sa.cd_endereco_segurado
					   and sa.cd_segurado =
					       se.cd_segurado
					   and sa.cd_sistema_origem =
					       se.cd_sistema_origem
					   and sa.cd_companhia_segur_emissao =
					       global_cd_cia_seguradora
					   and sa.cd_ramo_produto =
					       p_cd_ramo_apoli
					   and sa.cd_apolice = p_cd_apoli
					   and sa.cd_tipo_endosso =
					       p_cd_tipo_endos
					   and sa.cd_endosso = p_cd_endos;
				exception
					when others then
						p_id_cep_sgrdo             := null;
						p_nm_logra_loc_sgrdo       := null;
						p_nr_logra_loc_sgrdo       := null;
						p_nm_bairro_loc_sgrdo      := null;
						p_nm_cidad_loc_sgrdo       := null;
						p_sg_unidd_fedrc_loc_sgrdo := null;
						p_ds_complemento_sgrdo     := null;
				end;
			end if;
			--
		end if;
		--
		if p_nm_logra_loc_sinis is null then
			p_cd_mesmo_endereco_segurado := null;
		else
			if nvl(p_id_cep_local_sinis, 0) =
			   nvl(p_id_cep_sgrdo, 0) and
			   nvl(p_nm_logra_loc_sinis, '0') =
			   nvl(p_nm_logra_loc_sgrdo, '0') and
			   nvl(to_char(p_nr_logra_loc_sinis), '0') =
			   nvl(p_nr_logra_loc_sgrdo, '0') and
			   nvl(p_nm_bairro_loc_sinis, '0') =
			   nvl(p_nm_bairro_loc_sgrdo, '0') and
			   nvl(p_nm_cidad_loc_sinis, '0') =
			   nvl(p_nm_cidad_loc_sgrdo, '0') and
			   nvl(p_sg_unidd_fedrc_loc_sinis, '0') =
			   nvl(p_sg_unidd_fedrc_loc_sgrdo, '0') then
				p_cd_mesmo_endereco_segurado := 'S';
			else
				p_cd_mesmo_endereco_segurado := 'N';
			end if;
		end if;
		--
		commit;
	exception
		when v_saida_anormal then
			commit;
			p_mens := 'SINI7070_008.PRC_INICIA_AVISO - ' ||
				  p_mens;
			open p_tab_terceiro_re for
				select null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null
				  from dual;
			return;
		when others then
			commit;
			p_mens := 'SINI7070_008.PRC_INICIA_AVISO - Erro geral: ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			open p_tab_terceiro_re for
				select null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null,
				       null
				  from dual;
			return;
	end;

	-- Chamada Heryson
	procedure prc_inicia_aviso(p_id_aviso_sinst_re_sgrdo in out number,
				   p_cd_cia_sgdra            in out number,
				   p_cd_ramo_apoli           in out number,
				   p_cd_local_apoli          in out number,
				   p_cd_apoli                in out number,
				   p_cd_item_apoli           in out number,
				   p_cd_tipo_endos           in out number,
				   p_cd_endos                in out number,
				   p_cd_prdut                in out number,
				   p_dt_arquv                in out date,
				   p_dt_ocorrencia           in out date,
				   p_cd_tipo_bem_segurado    in out number,
				   p_cd_carac_bem_segurado   in out number,
				   p_cd_ramo_cobertura       in out number,
				   p_id_chave_acsel          in varchar2,
				   p_id_perfil_usuario       in varchar2, --"I"=Interno | "E"=Externo | "C"=Callcenter
				   p_ds_item_apolice         in out varchar2,
				   -- OS 11011
				   p_id_sistema_origem in number,
				   -- OS 228487 -Endesa
				   p_id_matricula in varchar2,
				   -- OS 11011
				   p_dt_inico_vigen              out date,
				   p_dt_termn_vigen              out date,
				   p_cd_crtor                    out number,
				   p_nm_crtor                    out varchar2,
				   p_cd_sgrdo                    out number,
				   p_nm_sgrdo                    out varchar2,
				   p_cd_tipo_sgrdo               out varchar2,
				   p_ds_tipo_sgrdo               out varchar2,
				   p_nr_cpf_cnpj_sgrdo           out number,
				   p_nr_ddd_telef_resdl_sgrdo    out number,
				   p_nr_telef_resdl_sgrdo        out number,
				   p_nr_ddd_telef_comrl_sgrdo    out number,
				   p_nr_telef_comrl_sgrdo        out number,
				   p_nr_ddd_celul_sgrdo          out number,
				   p_nr_telef_celul_sgrdo        out number,
				   p_nm_logra_loc_risco          out varchar2,
				   p_nr_logra_loc_risco          out number,
				   p_ds_cmplo_loc_risco          out varchar2,
				   p_nm_cidad_loc_risco          out varchar2,
				   p_sg_unidd_fedrc_loc_risco    out varchar2,
				   p_cd_comunicante_aviso        out varchar2,
				   p_cd_exite_terc               out varchar2,
				   p_ds_bem_segur                out varchar2,
				   p_nm_comnt                    out varchar2,
				   p_nr_ddd_telef_comrl_comnt    out number,
				   p_nr_telef_comrl_comnt        out number,
				   p_nr_ddd_celul_comnt          out number,
				   p_nr_telef_celul_comnt        out number,
				   p_cd_email_comnt              out varchar2,
				   p_ic_comnt_contt              out varchar2,
				   p_nm_contt                    out varchar2,
				   p_nr_ddd_comrl_contt          out number,
				   p_nr_telef_comrl_contt        out number,
				   p_nr_ddd_celul_contt          out number,
				   p_nr_telef_celul_contt        out number,
				   p_cd_email_contt              out varchar2,
				   p_cd_forma_contt              out varchar2,
				   p_cd_envia_sms_contt          out varchar2,
				   p_cd_num_bo                   out varchar2,
				   p_id_deleg_bo                 out number,
				   p_id_cep_local_sinis          out number,
				   p_nm_logra_loc_sinis          out varchar2,
				   p_nr_logra_loc_sinis          out number,
				   p_ds_complemento_loc_sinis    out varchar2,
				   p_nm_bairro_loc_sinis         out varchar2,
				   p_nm_cidad_loc_sinis          out varchar2,
				   p_sg_unidd_fedrc_loc_sinis    out varchar2,
				   p_ds_descr_sinis              out varchar2,
				   p_id_tipo_ocorr_sinis         out number,
				   p_id_cober_sinis              out number,
				   p_cd_cobertura_basica         out number,
				   p_cd_cobertura_adicional      out number,
				   p_cd_cobertura_especial       out number,
				   p_cd_cobertura_espec_especial out number,
				   p_cd_sequencia_cobertura      out number,
				   p_id_esti_prej_sinis          out number,
				   p_id_faixa_sinis              out number,
				   p_cd_bens_dani_sinis          out varchar2,
				   p_cd_observ_sinis             out varchar2,
				   p_nm_transportadora           out varchar2,
				   p_cd_nota_fiscal              out varchar2,
				   p_cd_chassi                   out varchar2,
				   p_cd_ctrc                     out varchar2,
				   p_ds_produto                  out varchar2,
				   p_id_tipo_operacao            out number,
				   --
				   p_id_cep_sgrdo             out number,
				   p_nm_logra_loc_sgrdo       out varchar2,
				   p_nr_logra_loc_sgrdo       out varchar2,
				   p_nm_bairro_loc_sgrdo      out varchar2,
				   p_nm_cidad_loc_sgrdo       out varchar2,
				   p_sg_unidd_fedrc_loc_sgrdo out varchar2,
				   p_ds_complemento_sgrdo     out varchar2,
				   --
				   p_cd_mesmo_endereco_segurado out varchar2,
				   p_cd_autoriza_envio_email    out varchar2,
				   --
				   p_tab_terceiro_re            out tab_terceiro_re,
				   p_cd_benefsinis_assistencia  out number,
				   p_nm_outro_prest_assistencia out varchar2,
				   p_cd_email_prest_assistencia out varchar2,
				   p_mens                       out varchar2,
				   p_idelpol			in	number	default	null,--OS Transporte
				   p_id_tipo_recepcao		in	number	default null --OS PagBank
				   ) is
		v_vl_qt_itens_sinist number := null;
	begin
		prc_inicia_aviso(p_id_aviso_sinst_re_sgrdo,
				 p_cd_cia_sgdra,
				 p_cd_ramo_apoli,
				 p_cd_local_apoli,
				 p_cd_apoli,
				 p_cd_item_apoli,
				 p_cd_tipo_endos,
				 p_cd_endos,
				 p_cd_prdut,
				 p_dt_arquv,
				 p_dt_ocorrencia,
				 p_cd_tipo_bem_segurado,
				 p_cd_carac_bem_segurado,
				 p_cd_ramo_cobertura,
				 p_id_chave_acsel,
				 p_id_perfil_usuario,
				 p_ds_item_apolice,
				 -- OS 11011
				 p_id_sistema_origem,
				 -- OS 228487 -Endesa
				 p_id_matricula,
				 -- OS 11011                         ,
				 p_dt_inico_vigen,
				 p_dt_termn_vigen,
				 p_cd_crtor,
				 p_nm_crtor,
				 p_cd_sgrdo,
				 p_nm_sgrdo,
				 p_cd_tipo_sgrdo,
				 p_ds_tipo_sgrdo,
				 p_nr_cpf_cnpj_sgrdo,
				 p_nr_ddd_telef_resdl_sgrdo,
				 p_nr_telef_resdl_sgrdo,
				 p_nr_ddd_telef_comrl_sgrdo,
				 p_nr_telef_comrl_sgrdo,
				 p_nr_ddd_celul_sgrdo,
				 p_nr_telef_celul_sgrdo,
				 p_nm_logra_loc_risco,
				 p_nr_logra_loc_risco,
				 p_ds_cmplo_loc_risco,
				 p_nm_cidad_loc_risco,
				 p_sg_unidd_fedrc_loc_risco,
				 p_cd_comunicante_aviso,
				 p_cd_exite_terc,
				 p_ds_bem_segur,
				 p_nm_comnt,
				 p_nr_ddd_telef_comrl_comnt,
				 p_nr_telef_comrl_comnt,
				 p_nr_ddd_celul_comnt,
				 p_nr_telef_celul_comnt,
				 p_cd_email_comnt,
				 p_ic_comnt_contt,
				 p_nm_contt,
				 p_nr_ddd_comrl_contt,
				 p_nr_telef_comrl_contt,
				 p_nr_ddd_celul_contt,
				 p_nr_telef_celul_contt,
				 p_cd_email_contt,
				 p_cd_forma_contt,
				 p_cd_envia_sms_contt,
				 p_cd_num_bo,
				 p_id_deleg_bo,
				 p_id_cep_local_sinis,
				 p_nm_logra_loc_sinis,
				 p_nr_logra_loc_sinis,
				 p_ds_complemento_loc_sinis,
				 p_nm_bairro_loc_sinis,
				 p_nm_cidad_loc_sinis,
				 p_sg_unidd_fedrc_loc_sinis,
				 p_ds_descr_sinis,
				 p_id_tipo_ocorr_sinis,
				 p_id_cober_sinis,
				 p_cd_cobertura_basica,
				 p_cd_cobertura_adicional,
				 p_cd_cobertura_especial,
				 p_cd_cobertura_espec_especial,
				 p_cd_sequencia_cobertura,
				 p_id_esti_prej_sinis,
				 p_id_faixa_sinis,
				 p_cd_bens_dani_sinis,
				 p_cd_observ_sinis,
				 p_nm_transportadora,
				 p_cd_nota_fiscal,
				 p_cd_chassi,
				 p_cd_ctrc,
				 p_ds_produto,
				 p_id_tipo_operacao,
				 --
				 p_id_cep_sgrdo,
				 p_nm_logra_loc_sgrdo,
				 p_nr_logra_loc_sgrdo,
				 p_nm_bairro_loc_sgrdo,
				 p_nm_cidad_loc_sgrdo,
				 p_sg_unidd_fedrc_loc_sgrdo,
				 p_ds_complemento_sgrdo,
				 --
				 p_cd_mesmo_endereco_segurado,
				 p_cd_autoriza_envio_email,
				 --
				 p_tab_terceiro_re,
				 p_cd_benefsinis_assistencia,
				 p_nm_outro_prest_assistencia,
				 p_cd_email_prest_assistencia,
				 v_vl_qt_itens_sinist,
				 p_mens,
				 p_idelpol,
				 p_id_tipo_recepcao --OS PagBank
				 );

	end;
	-- Chamada Sergio
	procedure prc_inicia_aviso(p_id_aviso_sinst_re_sgrdo in out number,
				   p_cd_cia_sgdra            in out number,
				   p_cd_ramo_apoli           in out number,
				   p_cd_local_apoli          in out number,
				   p_cd_apoli                in out number,
				   p_cd_item_apoli           in out number,
				   p_cd_tipo_endos           in out number,
				   p_cd_endos                in out number,
				   p_cd_prdut                in out number,
				   p_dt_arquv                in out date,
				   p_dt_ocorrencia           in out date,
				   p_cd_tipo_bem_segurado    in out number,
				   p_cd_carac_bem_segurado   in out number,
				   p_cd_ramo_cobertura       in out number,
				   p_id_chave_acsel          in varchar2,
				   p_id_perfil_usuario       in varchar2, --"I"=Interno | "E"=Externo | "C"=Callcenter
				   p_ds_item_apolice         in out varchar2,
				   -- OS 11011
				   p_id_sistema_origem in number,
				   -- OS 228487 -Endesa
				   p_id_matricula in varchar2,
				   -- OS 11011
				   p_dt_inico_vigen              out date,
				   p_dt_termn_vigen              out date,
				   p_cd_crtor                    out number,
				   p_nm_crtor                    out varchar2,
				   p_cd_sgrdo                    out number,
				   p_nm_sgrdo                    out varchar2,
				   p_cd_tipo_sgrdo               out varchar2,
				   p_ds_tipo_sgrdo               out varchar2,
				   p_nr_cpf_cnpj_sgrdo           out number,
				   p_nr_ddd_telef_resdl_sgrdo    out number,
				   p_nr_telef_resdl_sgrdo        out number,
				   p_nr_ddd_telef_comrl_sgrdo    out number,
				   p_nr_telef_comrl_sgrdo        out number,
				   p_nr_ddd_celul_sgrdo          out number,
				   p_nr_telef_celul_sgrdo        out number,
				   p_nm_logra_loc_risco          out varchar2,
				   p_nr_logra_loc_risco          out number,
				   p_ds_cmplo_loc_risco          out varchar2,
				   p_nm_cidad_loc_risco          out varchar2,
				   p_sg_unidd_fedrc_loc_risco    out varchar2,
				   p_cd_comunicante_aviso        out varchar2,
				   p_cd_exite_terc               out varchar2,
				   p_ds_bem_segur                out varchar2,
				   p_nm_comnt                    out varchar2,
				   p_nr_ddd_telef_comrl_comnt    out number,
				   p_nr_telef_comrl_comnt        out number,
				   p_nr_ddd_celul_comnt          out number,
				   p_nr_telef_celul_comnt        out number,
				   p_cd_email_comnt              out varchar2,
				   p_ic_comnt_contt              out varchar2,
				   p_nm_contt                    out varchar2,
				   p_nr_ddd_comrl_contt          out number,
				   p_nr_telef_comrl_contt        out number,
				   p_nr_ddd_celul_contt          out number,
				   p_nr_telef_celul_contt        out number,
				   p_cd_email_contt              out varchar2,
				   p_cd_forma_contt              out varchar2,
				   p_cd_envia_sms_contt          out varchar2,
				   p_cd_num_bo                   out varchar2,
				   p_id_deleg_bo                 out number,
				   p_id_cep_local_sinis          out number,
				   p_nm_logra_loc_sinis          out varchar2,
				   p_nr_logra_loc_sinis          out number,
				   p_ds_complemento_loc_sinis    out varchar2,
				   p_nm_bairro_loc_sinis         out varchar2,
				   p_nm_cidad_loc_sinis          out varchar2,
				   p_sg_unidd_fedrc_loc_sinis    out varchar2,
				   p_ds_descr_sinis              out varchar2,
				   p_id_tipo_ocorr_sinis         out number,
				   p_id_cober_sinis              out number,
				   p_cd_cobertura_basica         out number,
				   p_cd_cobertura_adicional      out number,
				   p_cd_cobertura_especial       out number,
				   p_cd_cobertura_espec_especial out number,
				   p_cd_sequencia_cobertura      out number,
				   p_id_esti_prej_sinis          out number,
				   p_id_faixa_sinis              out number,
				   p_cd_bens_dani_sinis          out varchar2,
				   p_cd_observ_sinis             out varchar2,
				   p_nm_transportadora           out varchar2,
				   p_cd_nota_fiscal              out varchar2,
				   p_cd_chassi                   out varchar2,
				   p_cd_ctrc                     out varchar2,
				   p_ds_produto                  out varchar2,
				   p_id_tipo_operacao            out number,
				   --
				   p_id_cep_sgrdo             out number,
				   p_nm_logra_loc_sgrdo       out varchar2,
				   p_nr_logra_loc_sgrdo       out varchar2,
				   p_nm_bairro_loc_sgrdo      out varchar2,
				   p_nm_cidad_loc_sgrdo       out varchar2,
				   p_sg_unidd_fedrc_loc_sgrdo out varchar2,
				   p_ds_complemento_sgrdo     out varchar2,
				   --
				   p_cd_mesmo_endereco_segurado out varchar2,
				   p_cd_autoriza_envio_email    out varchar2,
				   --
				   p_tab_terceiro_re    out tab_terceiro_re,
				   p_vl_qt_itens_sinist in number,
				   p_mens               out varchar2,
				   p_idelpol			in	number	default	null,--OS Transporte
				   p_id_tipo_recepcao		in	number	default null --OS PagBank
				   ) is

		v_cd_benefsinis_assistencia  number := null;
		v_nm_outro_prest_assistencia varchar2(100) := null;
		v_cd_email_prest_assistencia varchar2(50) := null;

	begin
		prc_inicia_aviso(p_id_aviso_sinst_re_sgrdo,
				 p_cd_cia_sgdra,
				 p_cd_ramo_apoli,
				 p_cd_local_apoli,
				 p_cd_apoli,
				 p_cd_item_apoli,
				 p_cd_tipo_endos,
				 p_cd_endos,
				 p_cd_prdut,
				 p_dt_arquv,
				 p_dt_ocorrencia,
				 p_cd_tipo_bem_segurado,
				 p_cd_carac_bem_segurado,
				 p_cd_ramo_cobertura,
				 p_id_chave_acsel,
				 p_id_perfil_usuario,
				 p_ds_item_apolice,
				 -- OS 11011
				 p_id_sistema_origem,
				 -- OS 228487 -Endesa
				 p_id_matricula,
				 -- OS 11011                         ,
				 p_dt_inico_vigen,
				 p_dt_termn_vigen,
				 p_cd_crtor,
				 p_nm_crtor,
				 p_cd_sgrdo,
				 p_nm_sgrdo,
				 p_cd_tipo_sgrdo,
				 p_ds_tipo_sgrdo,
				 p_nr_cpf_cnpj_sgrdo,
				 p_nr_ddd_telef_resdl_sgrdo,
				 p_nr_telef_resdl_sgrdo,
				 p_nr_ddd_telef_comrl_sgrdo,
				 p_nr_telef_comrl_sgrdo,
				 p_nr_ddd_celul_sgrdo,
				 p_nr_telef_celul_sgrdo,
				 p_nm_logra_loc_risco,
				 p_nr_logra_loc_risco,
				 p_ds_cmplo_loc_risco,
				 p_nm_cidad_loc_risco,
				 p_sg_unidd_fedrc_loc_risco,
				 p_cd_comunicante_aviso,
				 p_cd_exite_terc,
				 p_ds_bem_segur,
				 p_nm_comnt,
				 p_nr_ddd_telef_comrl_comnt,
				 p_nr_telef_comrl_comnt,
				 p_nr_ddd_celul_comnt,
				 p_nr_telef_celul_comnt,
				 p_cd_email_comnt,
				 p_ic_comnt_contt,
				 p_nm_contt,
				 p_nr_ddd_comrl_contt,
				 p_nr_telef_comrl_contt,
				 p_nr_ddd_celul_contt,
				 p_nr_telef_celul_contt,
				 p_cd_email_contt,
				 p_cd_forma_contt,
				 p_cd_envia_sms_contt,
				 p_cd_num_bo,
				 p_id_deleg_bo,
				 p_id_cep_local_sinis,
				 p_nm_logra_loc_sinis,
				 p_nr_logra_loc_sinis,
				 p_ds_complemento_loc_sinis,
				 p_nm_bairro_loc_sinis,
				 p_nm_cidad_loc_sinis,
				 p_sg_unidd_fedrc_loc_sinis,
				 p_ds_descr_sinis,
				 p_id_tipo_ocorr_sinis,
				 p_id_cober_sinis,
				 p_cd_cobertura_basica,
				 p_cd_cobertura_adicional,
				 p_cd_cobertura_especial,
				 p_cd_cobertura_espec_especial,
				 p_cd_sequencia_cobertura,
				 p_id_esti_prej_sinis,
				 p_id_faixa_sinis,
				 p_cd_bens_dani_sinis,
				 p_cd_observ_sinis,
				 p_nm_transportadora,
				 p_cd_nota_fiscal,
				 p_cd_chassi,
				 p_cd_ctrc,
				 p_ds_produto,
				 p_id_tipo_operacao,
				 --
				 p_id_cep_sgrdo,
				 p_nm_logra_loc_sgrdo,
				 p_nr_logra_loc_sgrdo,
				 p_nm_bairro_loc_sgrdo,
				 p_nm_cidad_loc_sgrdo,
				 p_sg_unidd_fedrc_loc_sgrdo,
				 p_ds_complemento_sgrdo,
				 --
				 p_cd_mesmo_endereco_segurado,
				 p_cd_autoriza_envio_email,
				 --
				 p_tab_terceiro_re,
				 v_cd_benefsinis_assistencia,
				 v_nm_outro_prest_assistencia,
				 v_cd_email_prest_assistencia,
				 p_vl_qt_itens_sinist,
				 p_mens,
				 p_idelpol,
				 p_id_tipo_recepcao --OS PagBank
				 );

	end;

	/***********************************************************************************
        prc_verifica_insert_update
            Author  : Michael Dossa
            Created : 03/04/2012
            Purpose : Rotina responsavel por verificar se existe registro na tabela ASW0016_AVISO_SINST_RE_SGRDO.
            ***********************************************************************************/
	procedure prc_verifica_insert_update(p_cd_cia_sgdra   in number,
					     p_cd_ramo_apoli  in number,
					     p_cd_local_apoli in number,
					     p_cd_apoli       in number,
					     p_cd_item_apoli  in number,
					     --p_cd_tipo_endos        in        number    ,
					     --p_cd_endos             in        number    ,
					     p_cd_prdut                in number,
					     p_dt_ocorrencia           in date,
					     p_acao                    out varchar2,
					     p_id_aviso_sinst_re_sgrdo out number,
					     p_mens                    out varchar2) is
		v_saida_anormal exception;
	begin
		p_acao                    := 'I';
		p_id_aviso_sinst_re_sgrdo := null;
		begin
			select max(id_aviso_sinst_re_sgrdo)
			  into p_id_aviso_sinst_re_sgrdo
			  from asw0016_aviso_sinst_re_sgrdo
			 where nvl(cd_cia_sgdra, 0) =
			       nvl(p_cd_cia_sgdra, 0)
			   and nvl(cd_ramo_apoli, 0) =
			       nvl(p_cd_ramo_apoli, 0)
			   and nvl(cd_local_apoli, 0) =
			       nvl(p_cd_local_apoli, 0)
			   and nvl(cd_apoli, 0) = nvl(p_cd_apoli, 0)
			   and nvl(cd_item_apoli, 0) =
			       nvl(p_cd_item_apoli, 0)
			      --and    nvl(cd_tipo_endos,0)         =    nvl(p_cd_tipo_endos,0)
			      --and    nvl(cd_endos,0)              =    nvl(p_cd_endos,0)
			   and nvl(cd_prdut, 0) = nvl(p_cd_prdut, 0)
			   and nvl(to_char(dt_ocorrencia), 0) =
			       nvl(to_char(p_dt_ocorrencia), 0);
		exception
			when too_many_rows then
				p_mens := 'Mais de um registro na tabela ASW0016_AVISO_SINST_RE_SGRDO com estes parametros.';
				raise v_saida_anormal;
			when others then
				p_acao                    := 'I';
				p_id_aviso_sinst_re_sgrdo := null;
		end;
		if p_id_aviso_sinst_re_sgrdo is not null then
			p_acao := 'U';
		end if;
	exception
		when v_saida_anormal then
			p_mens := 'SINI7070_008.PRC_VERIFICA_INSERT_UPDATE - Erro: ' ||
				  p_mens;
			return;
		when others then
			p_mens := 'SINI7070_008.PRC_VERIFICA_INSERT_UPDATE - Erro Geral: ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			return;
	end;

	/***********************************************************************************
        prc_insere_asw0016
            Author  : Michael Dossa
            Created : 03/04/2012
            Purpose : Rotina responsavel por inserir na tabela ASW0016_AVISO_SINST_RE_SGRDO.
        ***********************************************************************************/
	procedure prc_insere_asw0016(p_id_aviso_sinst_re_sgrdo  out number,
				     p_cd_cia_sgdra             in number,
				     p_cd_ramo_apoli            in number,
				     p_cd_local_apoli           in number,
				     p_cd_apoli                 in number,
				     p_cd_item_apoli            in number,
				     p_cd_tipo_endos            in number,
				     p_cd_endos                 in number,
				     p_cd_prdut                 in number,
				     p_dt_arquv                 in date,
				     p_dt_ocorrencia            in date,
				     p_dt_inico_vigen           in date,
				     p_dt_termn_vigen           in date,
				     p_cd_tipo_bem_segurado     in number,
				     p_cd_carac_bem_segurado    in number,
				     p_cd_ramo_cobertura        in number,
				     p_cd_crtor                 in number,
				     p_nm_crtor                 in varchar2,
				     p_cd_sgrdo                 in number,
				     p_nm_sgrdo                 in varchar2,
				     p_cd_tipo_sgrdo            in varchar2,
				     p_ds_tipo_sgrdo            in varchar2,
				     p_nr_cpf_cnpj_sgrdo        in number,
				     p_nr_ddd_telef_resdl_sgrdo in number,
				     p_nr_telef_resdl_sgrdo     in number,
				     p_nr_ddd_telef_comrl_sgrdo in number,
				     p_nr_telef_comrl_sgrdo     in number,
				     p_nr_ddd_celul_sgrdo       in number,
				     p_nr_telef_celul_sgrdo     in number,
				     p_nm_logra_loc_risco       in varchar2,
				     p_nr_logra_loc_risco       in number,
				     p_ds_cmplo_loc_risco       in varchar2,
				     p_nm_cidad_loc_risco       in varchar2,
				     p_sg_unidd_fedrc_loc_risco in varchar2,
				     p_cd_comunicante_aviso     in varchar2,
				     p_cd_exite_terc            in varchar2,
				     p_ds_bem_segur             in varchar2,
				     p_nm_comnt                 in varchar2,
				     p_nr_ddd_telef_comrl_comnt in number,
				     p_nr_telef_comrl_comnt     in number,
				     p_nr_ddd_celul_comnt       in number,
				     p_nr_telef_celul_comnt     in number,
				     p_cd_email_comnt           in varchar2,
				     p_ic_comnt_contt           in varchar2,
				     p_nm_contt                 in varchar2,
				     p_nr_ddd_comrl_contt       in number,
				     p_nr_telef_comrl_contt     in number,
				     p_nr_ddd_celul_contt       in number,
				     p_nr_telef_celul_contt     in number,
				     p_cd_email_contt           in varchar2,
				     p_cd_forma_contt           in varchar2,
				     p_cd_envia_sms_contt       in varchar2,
				     p_cd_num_bo                in varchar2,
				     p_id_deleg_bo              in number,
				     p_id_cep_local_sinis       in number,
				     p_nm_logra_loc_sinis       in varchar2,
				     p_nr_logra_loc_sinis       in number,
				     p_nm_bairro_loc_sinis      in varchar2,
				     p_nm_cidad_loc_sinis       in varchar2,
				     p_sg_unidd_fedrc_loc_sinis in varchar2,
				     p_ds_descr_sinis           in varchar2,
				     p_id_tipo_ocorr_sinis      in number,
				     p_id_cober_sinis           in number,
				     p_id_esti_prej_sinis       in number,
				     p_id_faixa_sinis           in number,
				     p_cd_bens_dani_sinis       in varchar2,
				     p_cd_observ_sinis          in varchar2,
				     p_nm_transportadora        in varchar2,
				     p_cd_nota_fiscal           in varchar2,
				     p_cd_chassi                in varchar2,
				     p_cd_ctrc                  in varchar2,
				     p_id_perfil_usuario        in varchar2,
				     p_id_matricula             in varchar2, --Endesa
				     p_vl_qtde_itens_sinist     in number,
				     p_mens                     out varchar2
				     , p_nr_aviso		in number default null 		-- SinistroDigitalResidencial
				     , p_id_tipo_recepcao	in number default null		-- SinistroDigitalResidencial
				     , p_id_cober_adic_sinis	in number default null 		-- SinistroDigitalResidencial
				     , p_id_valor_prej_infor	in varchar2 default 'S'		-- SinistroDigitalResidencial
				     , p_vl_prej_infor		in number default null		-- SinistroDigitalResidencial
				     , p_id_canal_origem	in number default null		-- SinistroDigitalResidencial
				     , p_nm_usuario_inclusao	in varchar2 default user	-- SinistroDigitalResidencial
					,  p_ds_compl_loc_sinis	in varchar2 default null	-- SinistroDigitalResidencial
					, p_cd_autoriza_envio_email in varchar2 default null 	-- SinistroDigitalResidencial
				     )	is
		v_saida_anormal exception;
	begin
		begin
			select seq_asw00016_re_sgrdo.nextval
			  into p_id_aviso_sinst_re_sgrdo
			  from dual;
		exception
			when others then
				p_mens := 'Problemas ao acessar a sequence seq_asw00016_re_sgrdo - ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
		begin
			insert into asw0016_aviso_sinst_re_sgrdo
				(id_aviso_sinst_re_sgrdo,
				 cd_cia_sgdra,
				 cd_ramo_apoli,
				 cd_local_apoli,
				 cd_apoli,
				 cd_item_apoli,
				 cd_tipo_endos,
				 cd_endos,
				 cd_prdut,
				 dt_arquv,
				 dt_ocorrencia,
				 dt_inico_vigen,
				 dt_termn_vigen,
				 cd_ramo_cobertura,
				 cd_crtor,
				 nm_crtor,
				 cd_sgrdo,
				 nm_sgrdo,
				 cd_tipo_sgrdo,
				 ds_tipo_sgrdo,
				 nr_cpf_cnpj_sgrdo,
				 nr_ddd_telef_resdl_sgrdo,
				 nr_telef_resdl_sgrdo,
				 nr_ddd_telef_comrl_sgrdo,
				 nr_telef_comrl_sgrdo,
				 nr_ddd_celul_sgrdo,
				 nr_telef_celul_sgrdo,
				 nm_logra_loc_risco,
				 nr_logra_loc_risco,
				 ds_cmplo_loc_risco,
				 nm_cidad_loc_risco,
				 sg_unidd_fedrc_loc_risco,
				 cd_comunicante_aviso,
				 cd_exite_terc,
				 ds_bem_segur,
				 nm_comnt,
				 nr_ddd_telef_comrl_comnt,
				 nr_telef_comrl_comnt,
				 nr_ddd_celul_comnt,
				 nr_telef_celul_comnt,
				 cd_email_comnt,
				 ic_comnt_contt,
				 nm_contt,
				 nr_ddd_comrl_contt,
				 nr_telef_comrl_contt,
				 nr_ddd_celul_contt,
				 nr_telef_celul_contt,
				 cd_email_contt,
				 cd_forma_contt,
				 cd_envia_sms_contt,
				 cd_num_bo,
				 id_deleg_bo,
				 id_cep_local_sinis,
				 nm_logra_loc_sinis,
				 nr_logra_loc_sinis,
				 nm_bairro_loc_sinis,
				 nm_cidad_loc_sinis,
				 sg_unidd_fedrc_loc_sinis,
				 ds_descr_sinis,
				 id_tipo_ocorr_sinis,
				 id_cober_sinis,
				 vl_estimativa_prejuizo,
				 id_faixa_sinis,
				 cd_bens_dani_sinis,
				 cd_observ_sinis,
				 nm_transportadora,
				 cd_nota_fiscal,
				 cd_chassi,
				 cd_ctrc,
				 cd_tipo_bem_segrdo,
				 cd_carac_bem_segrdo,
				 nm_usuro_incls,
				 dt_incls,
				 id_perfil_usuario,
				 id_matricula,
				 vl_qtde_itens_sinist
				 ,nr_aviso
				 ,id_tipo_recepcao
				 , cd_cobertura_basica
				 , cd_cobertura_adicional
				 , id_valor_prej_informado
				 , vl_prej_informado
				 , id_canal_origem
				 , ds_complemento_loc_sinis
				 , cd_autoriza_envio_email)
			values
				(p_id_aviso_sinst_re_sgrdo,
				 p_cd_cia_sgdra,
				 p_cd_ramo_apoli,
				 p_cd_local_apoli,
				 p_cd_apoli,
				 p_cd_item_apoli,
				 p_cd_tipo_endos,
				 p_cd_endos,
				 p_cd_prdut,
				 p_dt_arquv,
				 p_dt_ocorrencia,
				 p_dt_inico_vigen,
				 p_dt_termn_vigen,
				 p_cd_ramo_cobertura,
				 p_cd_crtor,
				 p_nm_crtor,
				 p_cd_sgrdo,
				 p_nm_sgrdo,
				 p_cd_tipo_sgrdo,
				 p_ds_tipo_sgrdo,
				 p_nr_cpf_cnpj_sgrdo,
				 p_nr_ddd_telef_resdl_sgrdo,
				 p_nr_telef_resdl_sgrdo,
				 p_nr_ddd_telef_comrl_sgrdo,
				 p_nr_telef_comrl_sgrdo,
				 p_nr_ddd_celul_sgrdo,
				 p_nr_telef_celul_sgrdo,
				 p_nm_logra_loc_risco,
				 p_nr_logra_loc_risco,
				 p_ds_cmplo_loc_risco,
				 p_nm_cidad_loc_risco,
				 p_sg_unidd_fedrc_loc_risco,
				 p_cd_comunicante_aviso,
				 p_cd_exite_terc,
				 p_ds_bem_segur,
				 p_nm_comnt,
				 p_nr_ddd_telef_comrl_comnt,
				 p_nr_telef_comrl_comnt,
				 p_nr_ddd_celul_comnt,
				 p_nr_telef_celul_comnt,
				 p_cd_email_comnt,
				 p_ic_comnt_contt,
				 p_nm_contt,
				 p_nr_ddd_comrl_contt,
				 p_nr_telef_comrl_contt,
				 p_nr_ddd_celul_contt,
				 p_nr_telef_celul_contt,
				 p_cd_email_contt,
				 p_cd_forma_contt,
				 p_cd_envia_sms_contt,
				 p_cd_num_bo,
				 p_id_deleg_bo,
				 p_id_cep_local_sinis,
				 p_nm_logra_loc_sinis,
				 p_nr_logra_loc_sinis,
				 p_nm_bairro_loc_sinis,
				 p_nm_cidad_loc_sinis,
				 p_sg_unidd_fedrc_loc_sinis,
				 p_ds_descr_sinis,
				 p_id_tipo_ocorr_sinis,
				 p_id_cober_sinis,
				 p_id_esti_prej_sinis,
				 p_id_faixa_sinis,
				 p_cd_bens_dani_sinis,
				 p_cd_observ_sinis,
				 p_nm_transportadora,
				 p_cd_nota_fiscal,
				 p_cd_chassi,
				 p_cd_ctrc,
				 p_cd_tipo_bem_segurado,
				 p_cd_carac_bem_segurado,
				 nvl(p_nm_usuario_inclusao,user),
				 sysdate,
				 p_id_perfil_usuario,
				 p_id_matricula, --Endesa
				 p_vl_qtde_itens_sinist
				 ,p_nr_aviso
				 ,p_id_tipo_recepcao
				 ,p_id_cober_sinis
				 ,p_id_cober_adic_sinis
				 , p_id_valor_prej_infor
				 , p_vl_prej_infor
				 , p_id_canal_origem
				 , p_ds_compl_loc_sinis
				 , p_cd_autoriza_envio_email );
		exception
			when others then
				p_mens := 'Problemas ao tentar inserir na tabela asw0016_aviso_sinst_re_sgrdo - ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
	exception
		when v_saida_anormal then
			p_mens := 'SINI7070_008.PRC_INSERE_ASW0016 - ' ||
				  p_mens;
			return;
		when others then
			p_mens := 'SINI7070_008.PRC_INSERE_ASW0016 - ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			return;
	end;

	/***********************************************************************************
        prc_carrega_aviso_parcial
            Author  : Michael Dossa
            Created : 03/04/2012
            Purpose : Rotina responsavel por retornar dados da tabela ASW0016_AVISO_SINST_RE_SGRDO.
        ***********************************************************************************/
	procedure prc_carrega_aviso_parcial(p_id_aviso_sinst_re_sgrdo     in number,
					    p_cd_cia_sgdra                out number,
					    p_cd_ramo_apoli               out number,
					    p_cd_local_apoli              out number,
					    p_cd_apoli                    out number,
					    p_cd_item_apoli               out number,
					    p_cd_tipo_endos               out number,
					    p_cd_endos                    out number,
					    p_cd_prdut                    out number,
					    p_dt_arquv                    out date,
					    p_dt_ocorrencia               out date,
					    p_dt_inico_vigen              out date,
					    p_dt_termn_vigen              out date,
					    p_cd_ramo_cobertura           out number,
					    p_cd_crtor                    out number,
					    p_nm_crtor                    out varchar2,
					    p_cd_sgrdo                    out number,
					    p_nm_sgrdo                    out varchar2,
					    p_cd_tipo_sgrdo               out varchar2,
					    p_ds_tipo_sgrdo               out varchar2,
					    p_nr_cpf_cnpj_sgrdo           out number,
					    p_nr_ddd_telef_resdl_sgrdo    out number,
					    p_nr_telef_resdl_sgrdo        out number,
					    p_nr_ddd_telef_comrl_sgrdo    out number,
					    p_nr_telef_comrl_sgrdo        out number,
					    p_nr_ddd_celul_sgrdo          out number,
					    p_nr_telef_celul_sgrdo        out number,
					    p_nm_logra_loc_risco          out varchar2,
					    p_nr_logra_loc_risco          out number,
					    p_ds_cmplo_loc_risco          out varchar2,
					    p_nm_cidad_loc_risco          out varchar2,
					    p_sg_unidd_fedrc_loc_risco    out varchar2,
					    p_cd_comunicante_aviso        out varchar2,
					    p_cd_exite_terc               out varchar2,
					    p_nm_comnt                    out varchar2,
					    p_nr_ddd_telef_comrl_comnt    out number,
					    p_nr_telef_comrl_comnt        out number,
					    p_nr_ddd_celul_comnt          out number,
					    p_nr_telef_celul_comnt        out number,
					    p_cd_email_comnt              out varchar2,
					    p_ic_comnt_contt              out varchar2,
					    p_nm_contt                    out varchar2,
					    p_nr_ddd_comrl_contt          out number,
					    p_nr_telef_comrl_contt        out number,
					    p_nr_ddd_celul_contt          out number,
					    p_nr_telef_celul_contt        out number,
					    p_cd_email_contt              out varchar2,
					    p_cd_forma_contt              out varchar2,
					    p_cd_envia_sms_contt          out varchar2,
					    p_cd_num_bo                   out varchar2,
					    p_id_deleg_bo                 out number,
					    p_id_cep_local_sinis          out number,
					    p_nm_logra_loc_sinis          out varchar2,
					    p_nr_logra_loc_sinis          out number,
					    p_ds_complemento_loc_sinis    out varchar2,
					    p_nm_bairro_loc_sinis         out varchar2,
					    p_nm_cidad_loc_sinis          out varchar2,
					    p_sg_unidd_fedrc_loc_sinis    out varchar2,
					    p_ds_descr_sinis              out varchar2,
					    p_id_tipo_ocorr_sinis         out number,
					    p_id_cober_sinis              out number,
					    p_id_esti_prej_sinis          out number,
					    p_id_faixa_sinis              out number,
					    p_cd_bens_dani_sinis          out varchar2,
					    p_cd_observ_sinis             out varchar2,
					    p_nm_transportadora           out varchar2,
					    p_cd_nota_fiscal              out varchar2,
					    p_cd_chassi                   out varchar2,
					    p_cd_ctrc                     out varchar2,
					    p_cd_cobertura_basica         out number,
					    p_cd_cobertura_adicional      out number,
					    p_cd_cobertura_especial       out number,
					    p_cd_cobertura_espec_especial out number,
					    p_cd_sequencia_cobertura      out number,
					    p_ds_item_apolice             out varchar2,
					    p_cd_autoriza_envio_email     out varchar2,
					    p_mens                        out varchar2) is
		v_cd_benefsinis_assistencia  number := null;
		v_nm_outro_prest_assistencia varchar2(100) := null;
		v_cd_email_prest_assistencia varchar2(50) := null;
	begin
		-- dbms_output.put_line('Teste');
		sini7070_008.prc_carrega_aviso_parcial(p_id_aviso_sinst_re_sgrdo,
						       p_cd_cia_sgdra,
						       p_cd_ramo_apoli,
						       p_cd_local_apoli,
						       p_cd_apoli,
						       p_cd_item_apoli,
						       p_cd_tipo_endos,
						       p_cd_endos,
						       p_cd_prdut,
						       p_dt_arquv,
						       p_dt_ocorrencia,
						       p_dt_inico_vigen,
						       p_dt_termn_vigen,
						       p_cd_ramo_cobertura,
						       p_cd_crtor,
						       p_nm_crtor,
						       p_cd_sgrdo,
						       p_nm_sgrdo,
						       p_cd_tipo_sgrdo,
						       p_ds_tipo_sgrdo,
						       p_nr_cpf_cnpj_sgrdo,
						       p_nr_ddd_telef_resdl_sgrdo,
						       p_nr_telef_resdl_sgrdo,
						       p_nr_ddd_telef_comrl_sgrdo,
						       p_nr_telef_comrl_sgrdo,
						       p_nr_ddd_celul_sgrdo,
						       p_nr_telef_celul_sgrdo,
						       p_nm_logra_loc_risco,
						       p_nr_logra_loc_risco,
						       p_ds_cmplo_loc_risco,
						       p_nm_cidad_loc_risco,
						       p_sg_unidd_fedrc_loc_risco,
						       p_cd_comunicante_aviso,
						       p_cd_exite_terc,
						       p_nm_comnt,
						       p_nr_ddd_telef_comrl_comnt,
						       p_nr_telef_comrl_comnt,
						       p_nr_ddd_celul_comnt,
						       p_nr_telef_celul_comnt,
						       p_cd_email_comnt,
						       p_ic_comnt_contt,
						       p_nm_contt,
						       p_nr_ddd_comrl_contt,
						       p_nr_telef_comrl_contt,
						       p_nr_ddd_celul_contt,
						       p_nr_telef_celul_contt,
						       p_cd_email_contt,
						       p_cd_forma_contt,
						       p_cd_envia_sms_contt,
						       p_cd_num_bo,
						       p_id_deleg_bo,
						       p_id_cep_local_sinis,
						       p_nm_logra_loc_sinis,
						       p_nr_logra_loc_sinis,
						       p_ds_complemento_loc_sinis,
						       p_nm_bairro_loc_sinis,
						       p_nm_cidad_loc_sinis,
						       p_sg_unidd_fedrc_loc_sinis,
						       p_ds_descr_sinis,
						       p_id_tipo_ocorr_sinis,
						       p_id_cober_sinis,
						       p_id_esti_prej_sinis,
						       p_id_faixa_sinis,
						       p_cd_bens_dani_sinis,
						       p_cd_observ_sinis,
						       p_nm_transportadora,
						       p_cd_nota_fiscal,
						       p_cd_chassi,
						       p_cd_ctrc,
						       p_cd_cobertura_basica,
						       p_cd_cobertura_adicional,
						       p_cd_cobertura_especial,
						       p_cd_cobertura_espec_especial,
						       p_cd_sequencia_cobertura,
						       p_ds_item_apolice,
						       p_cd_autoriza_envio_email,
						       v_cd_benefsinis_assistencia,
						       v_nm_outro_prest_assistencia,
						       v_cd_email_prest_assistencia,
						       p_mens);
	end;

	procedure prc_carrega_aviso_parcial(p_id_aviso_sinst_re_sgrdo     in number,
					    p_cd_cia_sgdra                out number,
					    p_cd_ramo_apoli               out number,
					    p_cd_local_apoli              out number,
					    p_cd_apoli                    out number,
					    p_cd_item_apoli               out number,
					    p_cd_tipo_endos               out number,
					    p_cd_endos                    out number,
					    p_cd_prdut                    out number,
					    p_dt_arquv                    out date,
					    p_dt_ocorrencia               out date,
					    p_dt_inico_vigen              out date,
					    p_dt_termn_vigen              out date,
					    p_cd_ramo_cobertura           out number,
					    p_cd_crtor                    out number,
					    p_nm_crtor                    out varchar2,
					    p_cd_sgrdo                    out number,
					    p_nm_sgrdo                    out varchar2,
					    p_cd_tipo_sgrdo               out varchar2,
					    p_ds_tipo_sgrdo               out varchar2,
					    p_nr_cpf_cnpj_sgrdo           out number,
					    p_nr_ddd_telef_resdl_sgrdo    out number,
					    p_nr_telef_resdl_sgrdo        out number,
					    p_nr_ddd_telef_comrl_sgrdo    out number,
					    p_nr_telef_comrl_sgrdo        out number,
					    p_nr_ddd_celul_sgrdo          out number,
					    p_nr_telef_celul_sgrdo        out number,
					    p_nm_logra_loc_risco          out varchar2,
					    p_nr_logra_loc_risco          out number,
					    p_ds_cmplo_loc_risco          out varchar2,
					    p_nm_cidad_loc_risco          out varchar2,
					    p_sg_unidd_fedrc_loc_risco    out varchar2,
					    p_cd_comunicante_aviso        out varchar2,
					    p_cd_exite_terc               out varchar2,
					    p_nm_comnt                    out varchar2,
					    p_nr_ddd_telef_comrl_comnt    out number,
					    p_nr_telef_comrl_comnt        out number,
					    p_nr_ddd_celul_comnt          out number,
					    p_nr_telef_celul_comnt        out number,
					    p_cd_email_comnt              out varchar2,
					    p_ic_comnt_contt              out varchar2,
					    p_nm_contt                    out varchar2,
					    p_nr_ddd_comrl_contt          out number,
					    p_nr_telef_comrl_contt        out number,
					    p_nr_ddd_celul_contt          out number,
					    p_nr_telef_celul_contt        out number,
					    p_cd_email_contt              out varchar2,
					    p_cd_forma_contt              out varchar2,
					    p_cd_envia_sms_contt          out varchar2,
					    p_cd_num_bo                   out varchar2,
					    p_id_deleg_bo                 out number,
					    p_id_cep_local_sinis          out number,
					    p_nm_logra_loc_sinis          out varchar2,
					    p_nr_logra_loc_sinis          out number,
					    p_ds_complemento_loc_sinis    out varchar2,
					    p_nm_bairro_loc_sinis         out varchar2,
					    p_nm_cidad_loc_sinis          out varchar2,
					    p_sg_unidd_fedrc_loc_sinis    out varchar2,
					    p_ds_descr_sinis              out varchar2,
					    p_id_tipo_ocorr_sinis         out number,
					    p_id_cober_sinis              out number,
					    p_id_esti_prej_sinis          out number,
					    p_id_faixa_sinis              out number,
					    p_cd_bens_dani_sinis          out varchar2,
					    p_cd_observ_sinis             out varchar2,
					    p_nm_transportadora           out varchar2,
					    p_cd_nota_fiscal              out varchar2,
					    p_cd_chassi                   out varchar2,
					    p_cd_ctrc                     out varchar2,
					    p_cd_cobertura_basica         out number,
					    p_cd_cobertura_adicional      out number,
					    p_cd_cobertura_especial       out number,
					    p_cd_cobertura_espec_especial out number,
					    p_cd_sequencia_cobertura      out number,
					    p_ds_item_apolice             out varchar2,
					    p_cd_autoriza_envio_email     out varchar2,
					    p_cd_benefsinis_assistencia   out number,
					    p_nm_outro_prest_assistencia  out varchar2,
					    p_cd_email_prest_assistencia  out varchar2,
					    p_mens                        out varchar2) is
	begin
		select cd_cia_sgdra,
		       cd_ramo_apoli,
		       cd_local_apoli,
		       cd_apoli,
		       cd_item_apoli,
		       cd_tipo_endos,
		       cd_endos,
		       cd_prdut,
		       dt_arquv,
		       dt_ocorrencia,
		       dt_inico_vigen,
		       dt_termn_vigen,
		       cd_ramo_cobertura,
		       cd_crtor,
		       nm_crtor,
		       cd_sgrdo,
		       nm_sgrdo,
		       cd_tipo_sgrdo,
		       ds_tipo_sgrdo,
		       nr_cpf_cnpj_sgrdo,
		       nr_ddd_telef_resdl_sgrdo,
		       nr_telef_resdl_sgrdo,
		       nr_ddd_telef_comrl_sgrdo,
		       nr_telef_comrl_sgrdo,
		       nr_ddd_celul_sgrdo,
		       nr_telef_celul_sgrdo,
		       nm_logra_loc_risco,
		       nr_logra_loc_risco,
		       ds_cmplo_loc_risco,
		       nm_cidad_loc_risco,
		       sg_unidd_fedrc_loc_risco,
		       cd_comunicante_aviso,
		       cd_exite_terc,
		       ds_bem_segur,
		       nm_comnt,
		       nr_ddd_telef_comrl_comnt,
		       nr_telef_comrl_comnt,
		       nr_ddd_celul_comnt,
		       nr_telef_celul_comnt,
		       cd_email_comnt,
		       ic_comnt_contt,
		       nm_contt,
		       nr_ddd_comrl_contt,
		       nr_telef_comrl_contt,
		       nr_ddd_celul_contt,
		       nr_telef_celul_contt,
		       cd_email_contt,
		       cd_forma_contt,
		       cd_envia_sms_contt,
		       cd_num_bo,
		       id_deleg_bo,
		       id_cep_local_sinis,
		       nm_logra_loc_sinis,
		       nr_logra_loc_sinis,
		       ds_complemento_loc_sinis,
		       nm_bairro_loc_sinis,
		       nm_cidad_loc_sinis,
		       sg_unidd_fedrc_loc_sinis,
		       ds_descr_sinis,
		       id_tipo_ocorr_sinis,
		       id_cober_sinis,
		       vl_estimativa_prejuizo,
		       id_faixa_sinis,
		       cd_bens_dani_sinis,
		       cd_observ_sinis,
		       nm_transportadora,
		       cd_nota_fiscal,
		       cd_chassi,
		       cd_ctrc,
		       cd_cobertura_basica,
		       cd_cobertura_adicional,
		       cd_cobertura_especial,
		       cd_cobertura_espec_especial,
		       cd_sequencia_cobertura,
		       cd_autoriza_envio_email,
		       cd_benefsinis_assistencia,
		       nm_outro_prest_assistencia,
		       cd_email_prest_assistencia
		  into p_cd_cia_sgdra,
		       p_cd_ramo_apoli,
		       p_cd_local_apoli,
		       p_cd_apoli,
		       p_cd_item_apoli,
		       p_cd_tipo_endos,
		       p_cd_endos,
		       p_cd_prdut,
		       p_dt_arquv,
		       p_dt_ocorrencia,
		       p_dt_inico_vigen,
		       p_dt_termn_vigen,
		       p_cd_ramo_cobertura,
		       p_cd_crtor,
		       p_nm_crtor,
		       p_cd_sgrdo,
		       p_nm_sgrdo,
		       p_cd_tipo_sgrdo,
		       p_ds_tipo_sgrdo,
		       p_nr_cpf_cnpj_sgrdo,
		       p_nr_ddd_telef_resdl_sgrdo,
		       p_nr_telef_resdl_sgrdo,
		       p_nr_ddd_telef_comrl_sgrdo,
		       p_nr_telef_comrl_sgrdo,
		       p_nr_ddd_celul_sgrdo,
		       p_nr_telef_celul_sgrdo,
		       p_nm_logra_loc_risco,
		       p_nr_logra_loc_risco,
		       p_ds_cmplo_loc_risco,
		       p_nm_cidad_loc_risco,
		       p_sg_unidd_fedrc_loc_risco,
		       p_cd_comunicante_aviso,
		       p_cd_exite_terc,
		       p_ds_item_apolice,
		       p_nm_comnt,
		       p_nr_ddd_telef_comrl_comnt,
		       p_nr_telef_comrl_comnt,
		       p_nr_ddd_celul_comnt,
		       p_nr_telef_celul_comnt,
		       p_cd_email_comnt,
		       p_ic_comnt_contt,
		       p_nm_contt,
		       p_nr_ddd_comrl_contt,
		       p_nr_telef_comrl_contt,
		       p_nr_ddd_celul_contt,
		       p_nr_telef_celul_contt,
		       p_cd_email_contt,
		       p_cd_forma_contt,
		       p_cd_envia_sms_contt,
		       p_cd_num_bo,
		       p_id_deleg_bo,
		       p_id_cep_local_sinis,
		       p_nm_logra_loc_sinis,
		       p_nr_logra_loc_sinis,
		       p_ds_complemento_loc_sinis,
		       p_nm_bairro_loc_sinis,
		       p_nm_cidad_loc_sinis,
		       p_sg_unidd_fedrc_loc_sinis,
		       p_ds_descr_sinis,
		       p_id_tipo_ocorr_sinis,
		       p_id_cober_sinis,
		       p_id_esti_prej_sinis,
		       p_id_faixa_sinis,
		       p_cd_bens_dani_sinis,
		       p_cd_observ_sinis,
		       p_nm_transportadora,
		       p_cd_nota_fiscal,
		       p_cd_chassi,
		       p_cd_ctrc,
		       p_cd_cobertura_basica,
		       p_cd_cobertura_adicional,
		       p_cd_cobertura_especial,
		       p_cd_cobertura_espec_especial,
		       p_cd_sequencia_cobertura,
		       p_cd_autoriza_envio_email,
		       p_cd_benefsinis_assistencia,
		       p_nm_outro_prest_assistencia,
		       p_cd_email_prest_assistencia
		  from asw0016_aviso_sinst_re_sgrdo
		 where id_aviso_sinst_re_sgrdo = p_id_aviso_sinst_re_sgrdo;
	exception
		when others then
			p_mens := 'SINI7070_008.PRC_CARREGA_AVISO_PARCIAL - Problemas ao tentar selecionar dados parciais da tabela ASW0016_AVISO_SINST_RE_SGRDO - ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			return;
	end;

	/***********************************************************************************
            prc_update_asw0016
            Author  : Michael Dossa
            Created : 04/04/2012
            Purpose : Rotina responsavel por atualizar a tabela ASW0016_AVISO_SINST_RE_SGRDO.
        ***********************************************************************************/
	procedure prc_update_asw0016(p_id_aviso_sinst_re_sgrdo  in number,
				     p_cd_cia_sgdra             in number,
				     p_cd_ramo_apoli            in number,
				     p_cd_local_apoli           in number,
				     p_cd_apoli                 in number,
				     p_cd_item_apoli            in number,
				     p_cd_tipo_endos            in number,
				     p_cd_endos                 in number,
				     p_cd_prdut                 in number,
				     p_dt_arquv                 in date,
				     p_dt_ocorrencia            in date,
				     p_dt_inico_vigen           in date,
				     p_dt_termn_vigen           in date,
				     p_cd_ramo_cobertura        in number,
				     p_cd_crtor                 in number,
				     p_nm_crtor                 in varchar2,
				     p_cd_sgrdo                 in number,
				     p_nm_sgrdo                 in varchar2,
				     p_cd_tipo_sgrdo            in varchar2,
				     p_ds_tipo_sgrdo            in varchar2,
				     p_nr_cpf_cnpj_sgrdo        in number,
				     p_nr_ddd_telef_resdl_sgrdo in number,
				     p_nr_telef_resdl_sgrdo     in number,
				     p_nr_ddd_telef_comrl_sgrdo in number,
				     p_nr_telef_comrl_sgrdo     in number,
				     p_nr_ddd_celul_sgrdo       in number,
				     p_nr_telef_celul_sgrdo     in number,
				     p_nm_logra_loc_risco       in varchar2,
				     p_nr_logra_loc_risco       in number,
				     p_ds_cmplo_loc_risco       in varchar2,
				     p_nm_cidad_loc_risco       in varchar2,
				     p_sg_unidd_fedrc_loc_risco in varchar2,
				     p_id_tipo_comunicante      in number,
				     p_cd_existe_terc           in varchar2,
				     p_ds_bem_segur             in varchar2,
				     p_nm_comnt                 in varchar2,
				     p_nr_ddd_telef_comrl_comnt in number,
				     p_nr_telef_comrl_comnt     in number,
				     p_nr_ddd_celul_comnt       in number,
				     p_nr_telef_celul_comnt     in number,
				     p_cd_email_comnt           in varchar2,
				     p_ic_comnt_contt           in varchar2,
				     p_nm_contt                 in varchar2,
				     p_nr_ddd_comrl_contt       in number,
				     p_nr_telef_comrl_contt     in number,
				     p_nr_ddd_celul_contt       in number,
				     p_nr_telef_celul_contt     in number,
				     p_cd_email_contt           in varchar2,
				     p_cd_forma_contt           in varchar2,
				     p_cd_envia_sms_contt       in varchar2,
				     p_cd_num_bo                in varchar2,
				     p_id_deleg_bo              in number,
				     p_id_cep_local_sinis       in number,
				     p_nm_logra_loc_sinis       in varchar2,
				     p_nr_logra_loc_sinis       in number,
				     p_ds_complemento_loc_sinis in varchar2,
				     p_nm_bairro_loc_sinis      in varchar2,
				     p_nm_cidad_loc_sinis       in varchar2,
				     p_sg_unidd_fedrc_loc_sinis in varchar2,
				     p_ds_descr_sinis           in varchar2,
				     p_id_tipo_ocorr_sinis      in number,
				     p_id_cober_sinis           in number,
				     p_id_cober_basica          in number,
				     p_id_cober_adicional       in number,
				     p_id_cober_especial        in number,
				     p_id_cober_especial_esp    in number,
				     p_cd_sequencia             in number,
				     p_id_esti_prej_sinis       in number,
				     p_id_faixa_sinis           in number,
				     p_cd_bens_dani_sinis       in varchar2,
				     p_cd_observ_sinis          in varchar2,
				     p_nm_transportadora        in varchar2,
				     p_cd_nota_fiscal           in varchar2,
				     p_cd_chassi                in varchar2,
				     p_cd_ctrc                  in varchar2,
				     p_nm_usuro_incls           in varchar2,
				     p_id_perfil_usuario        in varchar2,
				     p_cd_autoriza_envio_email  in varchar2,
				     p_mens                     out varchar2) is
	begin
		sini7070_008.prc_update_asw0016(p_id_aviso_sinst_re_sgrdo,
						p_cd_cia_sgdra,
						p_cd_ramo_apoli,
						p_cd_local_apoli,
						p_cd_apoli,
						p_cd_item_apoli,
						p_cd_tipo_endos,
						p_cd_endos,
						p_cd_prdut,
						p_dt_arquv,
						p_dt_ocorrencia,
						p_dt_inico_vigen,
						p_dt_termn_vigen,
						p_cd_ramo_cobertura,
						p_cd_crtor,
						p_nm_crtor,
						p_cd_sgrdo,
						p_nm_sgrdo,
						p_cd_tipo_sgrdo,
						p_ds_tipo_sgrdo,
						p_nr_cpf_cnpj_sgrdo,
						p_nr_ddd_telef_resdl_sgrdo,
						p_nr_telef_resdl_sgrdo,
						p_nr_ddd_telef_comrl_sgrdo,
						p_nr_telef_comrl_sgrdo,
						p_nr_ddd_celul_sgrdo,
						p_nr_telef_celul_sgrdo,
						p_nm_logra_loc_risco,
						p_nr_logra_loc_risco,
						p_ds_cmplo_loc_risco,
						p_nm_cidad_loc_risco,
						p_sg_unidd_fedrc_loc_risco,
						p_id_tipo_comunicante,
						p_cd_existe_terc,
						p_ds_bem_segur,
						p_nm_comnt,
						p_nr_ddd_telef_comrl_comnt,
						p_nr_telef_comrl_comnt,
						p_nr_ddd_celul_comnt,
						p_nr_telef_celul_comnt,
						p_cd_email_comnt,
						p_ic_comnt_contt,
						p_nm_contt,
						p_nr_ddd_comrl_contt,
						p_nr_telef_comrl_contt,
						p_nr_ddd_celul_contt,
						p_nr_telef_celul_contt,
						p_cd_email_contt,
						p_cd_forma_contt,
						p_cd_envia_sms_contt,
						p_cd_num_bo,
						p_id_deleg_bo,
						p_id_cep_local_sinis,
						p_nm_logra_loc_sinis,
						p_nr_logra_loc_sinis,
						p_ds_complemento_loc_sinis,
						p_nm_bairro_loc_sinis,
						p_nm_cidad_loc_sinis,
						p_sg_unidd_fedrc_loc_sinis,
						p_ds_descr_sinis,
						p_id_tipo_ocorr_sinis,
						p_id_cober_sinis,
						p_id_cober_basica,
						p_id_cober_adicional,
						p_id_cober_especial,
						p_id_cober_especial_esp,
						p_cd_sequencia,
						p_id_esti_prej_sinis,
						p_id_faixa_sinis,
						p_cd_bens_dani_sinis,
						p_cd_observ_sinis,
						p_nm_transportadora,
						p_cd_nota_fiscal,
						p_cd_chassi,
						p_cd_ctrc,
						p_nm_usuro_incls,
						p_id_perfil_usuario,
						p_cd_autoriza_envio_email,
						null,
						null,
						null,
						p_mens);
	end;

	procedure prc_update_asw0016(p_id_aviso_sinst_re_sgrdo    in number,
				     p_cd_cia_sgdra               in number,
				     p_cd_ramo_apoli              in number,
				     p_cd_local_apoli             in number,
				     p_cd_apoli                   in number,
				     p_cd_item_apoli              in number,
				     p_cd_tipo_endos              in number,
				     p_cd_endos                   in number,
				     p_cd_prdut                   in number,
				     p_dt_arquv                   in date,
				     p_dt_ocorrencia              in date,
				     p_dt_inico_vigen             in date,
				     p_dt_termn_vigen             in date,
				     p_cd_ramo_cobertura          in number,
				     p_cd_crtor                   in number,
				     p_nm_crtor                   in varchar2,
				     p_cd_sgrdo                   in number,
				     p_nm_sgrdo                   in varchar2,
				     p_cd_tipo_sgrdo              in varchar2,
				     p_ds_tipo_sgrdo              in varchar2,
				     p_nr_cpf_cnpj_sgrdo          in number,
				     p_nr_ddd_telef_resdl_sgrdo   in number,
				     p_nr_telef_resdl_sgrdo       in number,
				     p_nr_ddd_telef_comrl_sgrdo   in number,
				     p_nr_telef_comrl_sgrdo       in number,
				     p_nr_ddd_celul_sgrdo         in number,
				     p_nr_telef_celul_sgrdo       in number,
				     p_nm_logra_loc_risco         in varchar2,
				     p_nr_logra_loc_risco         in number,
				     p_ds_cmplo_loc_risco         in varchar2,
				     p_nm_cidad_loc_risco         in varchar2,
				     p_sg_unidd_fedrc_loc_risco   in varchar2,
				     p_id_tipo_comunicante        in number,
				     p_cd_existe_terc             in varchar2,
				     p_ds_bem_segur               in varchar2,
				     p_nm_comnt                   in varchar2,
				     p_nr_ddd_telef_comrl_comnt   in number,
				     p_nr_telef_comrl_comnt       in number,
				     p_nr_ddd_celul_comnt         in number,
				     p_nr_telef_celul_comnt       in number,
				     p_cd_email_comnt             in varchar2,
				     p_ic_comnt_contt             in varchar2,
				     p_nm_contt                   in varchar2,
				     p_nr_ddd_comrl_contt         in number,
				     p_nr_telef_comrl_contt       in number,
				     p_nr_ddd_celul_contt         in number,
				     p_nr_telef_celul_contt       in number,
				     p_cd_email_contt             in varchar2,
				     p_cd_forma_contt             in varchar2,
				     p_cd_envia_sms_contt         in varchar2,
				     p_cd_num_bo                  in varchar2,
				     p_id_deleg_bo                in number,
				     p_id_cep_local_sinis         in number,
				     p_nm_logra_loc_sinis         in varchar2,
				     p_nr_logra_loc_sinis         in number,
				     p_ds_complemento_loc_sinis   in varchar2,
				     p_nm_bairro_loc_sinis        in varchar2,
				     p_nm_cidad_loc_sinis         in varchar2,
				     p_sg_unidd_fedrc_loc_sinis   in varchar2,
				     p_ds_descr_sinis             in varchar2,
				     p_id_tipo_ocorr_sinis        in number,
				     p_id_cober_sinis             in number,
				     p_id_cober_basica            in number,
				     p_id_cober_adicional         in number,
				     p_id_cober_especial          in number,
				     p_id_cober_especial_esp      in number,
				     p_cd_sequencia               in number,
				     p_id_esti_prej_sinis         in number,
				     p_id_faixa_sinis             in number,
				     p_cd_bens_dani_sinis         in varchar2,
				     p_cd_observ_sinis            in varchar2,
				     p_nm_transportadora          in varchar2,
				     p_cd_nota_fiscal             in varchar2,
				     p_cd_chassi                  in varchar2,
				     p_cd_ctrc                    in varchar2,
				     p_nm_usuro_incls             in varchar2,
				     p_id_perfil_usuario          in varchar2,
				     p_cd_autoriza_envio_email    in varchar2,
				     p_cd_benefsinis_assistencia  in number,
				     p_nm_outro_prest_assistencia in varchar2,
				     p_cd_email_prest_assistencia in varchar2,
				     p_mens                       out varchar2,
				     P_ID_NECESSIDADE_VISTORIA   IN VARCHAR2 DEFAULT NULL,
				     P_CD_TIPO_VISTORIA_SINISTRO IN NUMBER DEFAULT NULL,
				     P_CD_VISTORIADOR_SINISTRO   IN NUMBER DEFAULT NULL,
				     P_ID_NECESSIDADE_PERITO IN VARCHAR2 DEFAULT NULL,
				     P_CD_PERITO_SINISTRO    IN NUMBER DEFAULT NULL,
				     P_ID_PLACA  IN VARCHAR2 DEFAULT NULL,
				     P_VL_EMBARQUE   IN NUMBER DEFAULT NULL,
				     P_DT_CTRC   IN DATE DEFAULT NULL,
				     P_DS_ORIGEM IN VARCHAR2 DEFAULT NULL,
				     P_DS_DESTINO    IN VARCHAR2 DEFAULT NULL,
				     P_ID_CAUSA    IN VARCHAR2 DEFAULT NULL,
             P_ID_POSSUI_VEICULO    IN VARCHAR2 DEFAULT NULL,
             --CONTATO VISTORIA--
                     P_NM_CONTATO_VISTORIA IN VARCHAR2 DEFAULT NULL,
                     P_NR_DDD_CONTATO_VISTORIA IN NUMBER DEFAULT NULL,
                     P_NR_TEL_CONTATO_VISTORIA IN NUMBER DEFAULT NULL) is
		v_saida_anormal exception;
	begin
		if p_id_perfil_usuario is null then
			raise v_saida_anormal;
		end if;
		update asw0016_aviso_sinst_re_sgrdo
		   set --cd_cia_sgdra                    =         p_cd_cia_sgdra                        ,
		       --cd_ramo_apoli                  =     p_cd_ramo_apoli                 ,
		       --cd_local_apoli                 =     p_cd_local_apoli                ,
		       --cd_apoli                       =     p_cd_apoli                      ,
		       --cd_item_apoli                  =     p_cd_item_apoli                 ,
		       --cd_tipo_endos                  =     p_cd_tipo_endos                 ,
		       --cd_endos                       =     p_cd_endos                      ,
		       --cd_prdut                       =     p_cd_prdut                      ,
		       --dt_arquv                       =     p_dt_arquv                      ,
		       --dt_ocorrencia                  =     p_dt_ocorrencia                 ,
		       --dt_inico_vigen                 =     p_dt_inico_vigen                ,
		       --dt_termn_vigen                 =     p_dt_termn_vigen                ,
		       --cd_ramo_cobertura              =     p_cd_ramo_cobertura             ,
		       --cd_crtor                       =     p_cd_crtor                      ,
		       --nm_crtor                       =     p_nm_crtor                      ,
		       --cd_sgrdo                       =     p_cd_sgrdo                      ,
		       --nm_sgrdo                       =     p_nm_sgrdo                      ,
		       --cd_tipo_sgrdo                  =     p_cd_tipo_sgrdo                 ,
		       --ds_tipo_sgrdo                  =     p_ds_tipo_sgrdo                 ,
		       --nr_cpf_cnpj_sgrdo              =     p_nr_cpf_cnpj_sgrdo             ,
			       nr_ddd_telef_resdl_sgrdo = p_nr_ddd_telef_resdl_sgrdo,
		       nr_telef_resdl_sgrdo     = p_nr_telef_resdl_sgrdo,
		       nr_ddd_telef_comrl_sgrdo = p_nr_ddd_telef_comrl_sgrdo,
		       nr_telef_comrl_sgrdo     = p_nr_telef_comrl_sgrdo,
		       nr_ddd_celul_sgrdo       = p_nr_ddd_celul_sgrdo,
		       nr_telef_celul_sgrdo     = p_nr_telef_celul_sgrdo,
		       nm_logra_loc_risco       = p_nm_logra_loc_risco,
		       nr_logra_loc_risco       = p_nr_logra_loc_risco,
		       ds_cmplo_loc_risco       = p_ds_cmplo_loc_risco,
		       nm_cidad_loc_risco       = p_nm_cidad_loc_risco,
		       sg_unidd_fedrc_loc_risco = p_sg_unidd_fedrc_loc_risco,
		       cd_comunicante_aviso     = p_id_tipo_comunicante,
		       cd_exite_terc            = p_cd_existe_terc,
		       --ds_bem_segur                 =           p_ds_bem_segur                    ,
		       nm_comnt                    = p_nm_comnt,
		       nr_ddd_telef_comrl_comnt    = p_nr_ddd_telef_comrl_comnt,
		       nr_telef_comrl_comnt        = p_nr_telef_comrl_comnt,
		       nr_ddd_celul_comnt          = p_nr_ddd_celul_comnt,
		       nr_telef_celul_comnt        = p_nr_telef_celul_comnt,
		       cd_email_comnt              = p_cd_email_comnt,
		       ic_comnt_contt              = p_ic_comnt_contt,
		       nm_contt                    = p_nm_contt,
		       nr_ddd_comrl_contt          = p_nr_ddd_comrl_contt,
		       nr_telef_comrl_contt        = p_nr_telef_comrl_contt,
		       nr_ddd_celul_contt          = p_nr_ddd_celul_contt,
		       nr_telef_celul_contt        = p_nr_telef_celul_contt,
		       cd_email_contt              = p_cd_email_contt,
		       cd_forma_contt              = p_cd_forma_contt,
		       cd_envia_sms_contt          = p_cd_envia_sms_contt,
		       cd_num_bo                   = p_cd_num_bo,
		       id_deleg_bo                 = p_id_deleg_bo,
		       id_cep_local_sinis          = p_id_cep_local_sinis,
		       nm_logra_loc_sinis          = p_nm_logra_loc_sinis,
		       nr_logra_loc_sinis          = p_nr_logra_loc_sinis,
		       ds_complemento_loc_sinis    = p_ds_complemento_loc_sinis,
		       nm_bairro_loc_sinis         = p_nm_bairro_loc_sinis,
		       nm_cidad_loc_sinis          = p_nm_cidad_loc_sinis,
		       sg_unidd_fedrc_loc_sinis    = p_sg_unidd_fedrc_loc_sinis,
		       ds_descr_sinis              = p_ds_descr_sinis,
		       id_tipo_ocorr_sinis         = p_id_tipo_ocorr_sinis,
		       vl_estimativa_prejuizo      = p_id_esti_prej_sinis,
		       id_faixa_sinis              = p_id_faixa_sinis,
		       cd_bens_dani_sinis          = p_cd_bens_dani_sinis,
		       cd_observ_sinis             = p_cd_observ_sinis,
		       nm_transportadora           = p_nm_transportadora,
		       cd_nota_fiscal              = p_cd_nota_fiscal,
		       cd_chassi                   = p_cd_chassi,
		       cd_ctrc                     = p_cd_ctrc,
		       id_cober_sinis              = p_id_cober_sinis,
		       cd_cobertura_basica         = p_id_cober_basica,
		       cd_cobertura_adicional      = p_id_cober_adicional,
		       cd_cobertura_especial       = p_id_cober_especial,
		       cd_cobertura_espec_especial = p_id_cober_especial_esp,
		       cd_sequencia_cobertura      = p_cd_sequencia,
		       nm_usuro_alter              = p_nm_usuro_incls,
		       dt_alter                    = sysdate,
		       id_perfil_usuario           = p_id_perfil_usuario,
		       cd_autoriza_envio_email     = p_cd_autoriza_envio_email,
		       cd_benefsinis_assistencia   = p_cd_benefsinis_assistencia,
		       nm_outro_prest_assistencia  = p_nm_outro_prest_assistencia,
		       cd_email_prest_assistencia  = p_cd_email_prest_assistencia,
		       ID_NECESSIDADE_VISTORIA = P_ID_NECESSIDADE_VISTORIA,
		       CD_TIPO_VISTORIA_SINISTRO = P_CD_TIPO_VISTORIA_SINISTRO,
		       CD_VISTORIADOR_SINISTRO = P_CD_VISTORIADOR_SINISTRO,
		       ID_NECESSIDADE_PERITO = P_ID_NECESSIDADE_PERITO,
		       CD_PERITO_SINISTRO = P_CD_PERITO_SINISTRO,
		       ID_PLACA_TRANSPORTADOR = P_ID_PLACA,
		       VL_EMBARQUE = P_VL_EMBARQUE,
		       DT_CTRC = P_DT_CTRC,
		       DS_ORIGEM = P_DS_ORIGEM,
		       DS_DESTINO = P_DS_DESTINO,
           ID_CAUSA = P_ID_CAUSA,
           ID_POSSUI_VEICULO = P_ID_POSSUI_VEICULO,
       --CONTATO VISTORIA--
             NM_CONTATO_VISTORIA = P_NM_CONTATO_VISTORIA,
             NR_DDD_CONTATO_VISTORIA =  P_NR_DDD_CONTATO_VISTORIA,
             NR_TEL_CONTATO_VISTORIA =  P_NR_TEL_CONTATO_VISTORIA
		 where id_aviso_sinst_re_sgrdo = p_id_aviso_sinst_re_sgrdo;
	exception
		when v_saida_anormal then
			p_mens := 'SINI7070_008.PRC_UPDATE_ASW0016 - O perfil do usurio deve ser informado.';
		when others then
			p_mens := 'SINI7070_008.PRC_UPDATE_ASW0016 - Problemas ao atualizar tabela ASW0016_AVISO_SINST_RE_SGRDO. Erro - ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			return;
	end;
	--
	procedure prc_exclui_veiculos_residuais(P_ID_VEICULO_MAX	IN	NUMBER,
						P_CD_RECLAMACAO_ELEME	IN	NUMBER,
						P_MENS			OUT	VARCHAR2)
	IS
		v_count	number;
		v_saida_anormal exception;
	BEGIN
		begin
			select count(1)
			into	v_count
			from	asw0024_aviso_sinst_re_veic
			where	cd_reclamacao_elementar = P_CD_RECLAMACAO_ELEME;
		exception
			when others then
				p_mens := 'Falha ao verificar existencia de registros na asw0024_aviso_sinst_re_veic.: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;

		if v_count > P_ID_VEICULO_MAX then
			begin
				delete	asw0024_aviso_sinst_re_veic
				where	cd_reclamacao_elementar = P_CD_RECLAMACAO_ELEME
				and	id_veiculo > P_ID_VEICULO_MAX;
			exception
				when others then
					rollback;
					p_mens := 'Falha ao excluir registros residuais da asw0024_aviso_sinst_re_veic';
					raise v_saida_anormal;
			end;
			commit;
		end if;

	EXCEPTION
		when v_saida_anormal then
			p_mens := 'Falha ao executar prc_exclui_veiculos_residuais: ' || p_mens;
		when others then
			p_mens := 'Falha ao executar prc_exclui_veiculos_residuais: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	END;
	--
	procedure prc_insert_update_asw0024(	P_CD_RECLAMACAO_ELEME	IN	NUMBER,
						P_CD_RAMO_APOLI		IN	NUMBER,
						P_CD_APOLI		IN	NUMBER,
						P_CD_ITEM_APOLI		IN	NUMBER,
						P_CD_FABRICANTE		IN	NUMBER,
						P_CD_MODELO_VEICULO	IN	NUMBER,
						P_CD_COMBUSTIVEL	IN	NUMBER,
						P_CD_VEICULO		IN	NUMBER,
						P_CD_ANO_VEICULO	IN	NUMBER,
						P_ID_PLACA		IN	VARCHAR2,
						P_ID_VEICULO		IN	NUMBER,
						P_NM_USUARIO_INCLUSAO	IN	VARCHAR2 DEFAULT NULL,
						P_NM_USUARIO_ALTERACAO	IN	VARCHAR2 DEFAULT NULL,
						P_MENS			OUT	VARCHAR2)
	is
		v_count number;
		v_saida_anormal exception;
	begin
		begin
			select count(1)
			into	v_count
			from	asw0024_aviso_sinst_re_veic
			where	cd_reclamacao_elementar = P_CD_RECLAMACAO_ELEME
			and	id_veiculo = P_ID_VEICULO;
		exception
			when others then
				p_mens := 'Falha ao verificar existencia de registros na asw0024_aviso_sinst_re_veic.: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;

		if v_count = 0 then
			-- insert
			begin
				insert into asw0024_aviso_sinst_re_veic
					(
					cd_sequencia,
					cd_reclamacao_elementar,
					cd_ramo_apoli,
					cd_apoli,
					cd_item_apoli,
					cd_fabricante,
					cd_modelo_veiculo,
					cd_combustivel,
					cd_veiculo,
					cd_ano_veiculo,
					id_placa,
					id_veiculo,
					dt_inclusao,
					nm_usuario_inclusao
					)
				values
					(
					asw24_seq.nextval,
					P_CD_RECLAMACAO_ELEME,
					P_CD_RAMO_APOLI,
					P_CD_APOLI,
					P_CD_ITEM_APOLI,
					P_CD_FABRICANTE,
					P_CD_MODELO_VEICULO,
					P_CD_COMBUSTIVEL,
					P_CD_VEICULO,
					P_CD_ANO_VEICULO,
					P_ID_PLACA,
					P_ID_VEICULO,
					SYSDATE,
					USER
					);

			exception
				when others then
					rollback;
					p_mens:='Falha ao inserir na asw0024_aviso_sinst_re_veic: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			end;
			commit;
		elsif v_count = 1 then
			-- update
			begin
				update asw0024_aviso_sinst_re_veic
				set
					cd_ramo_apoli = P_CD_RAMO_APOLI,
					cd_apoli = P_CD_APOLI,
					cd_item_apoli = P_CD_ITEM_APOLI,
					cd_fabricante = P_CD_FABRICANTE,
					cd_modelo_veiculo = P_CD_MODELO_VEICULO,
					cd_combustivel = P_CD_COMBUSTIVEL,
					cd_veiculo = P_CD_VEICULO,
					cd_ano_veiculo = P_CD_ANO_VEICULO,
					id_placa = P_ID_PLACA,
					id_veiculo = P_ID_VEICULO,
					dt_alteracao = SYSDATE,
					nm_usuario_alteracao = USER
				where	cd_reclamacao_elementar = P_CD_RECLAMACAO_ELEME;
			exception
				when others then
					rollback;
					p_mens:='Falha ao atualizar asw0024_aviso_sinst_re_veic: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			end;
			commit;
		else
			p_mens := 'Mais de um registro encontrado na asw0024_aviso_sinst_re_veic para o aviso: ' || P_CD_RECLAMACAO_ELEME;
			raise v_saida_anormal;
		end if;
		--
	exception
		when v_saida_anormal then
			p_mens := 'Não foi possível inserir/atualizar asw0024_aviso_sinst_re_veic: ' || p_mens;
		when others then
			p_mens := 'Falha geral ao inserir/atualizar asw0024_aviso_sinst_re_veic: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	end;


	--
	/***********************************************************************************
        fnc_finaliza_aviso_re
        Author  : Rodrigo Abambres
        Created : 11/01/2016
        Purpose : Função responsvel por verificar se j existe aviso aberto para o segurado.
        ***********************************************************************************/
	function fnc_finaliza_aviso_re(p_id_aviso_sinst_re_sgrdo in number)
		return varchar2 is
		--
		v_ds_retorno varchar2(2000);
		--
		v_dt_ocorrencia           date;
		v_cd_aviso                number;
		v_cd_segurado             number;
		v_cd_cia_seguradora       number;
		v_cd_ramo_apolice         number;
		v_cd_apolice              number;
		v_cd_endosso              number;
		v_cd_tipo_endosso         number;
		v_cd_item_apolice         number;
		v_cd_natureza_sinistro    number;
		v_cd_cobertura_basica     number;
		v_cd_cobertura_adicional  number;
		v_nr_endereco_risco       number;
		v_id_uf_risco             varchar2(2);
		v_ds_endereco_risco       varchar2(200);
		v_ds_compl_endereco_risco varchar2(200);
		v_nm_cidade_risco         varchar2(200);
		v_mens                    varchar2(2000);
		v_saida_anormal exception;
		--
	begin
		--
		begin
			select a.cd_cia_sgdra,
			       a.cd_ramo_apoli,
			       a.cd_apoli,
			       a.cd_item_apoli,
			       a.cd_tipo_endos,
			       a.cd_endos,
			       a.cd_sgrdo,
			       a.dt_ocorrencia,
			       --
			       a.cd_cobertura_basica,
			       a.cd_cobertura_adicional,
			       a.id_tipo_ocorr_sinis,
			       --
			       a.nm_logra_loc_risco,
			       a.nr_logra_loc_risco,
			       a.ds_cmplo_loc_risco,
			       a.nm_cidad_loc_risco,
			       a.sg_unidd_fedrc_loc_risco
			  into v_cd_cia_seguradora,
			       v_cd_ramo_apolice,
			       v_cd_apolice,
			       v_cd_item_apolice,
			       v_cd_tipo_endosso,
			       v_cd_endosso,
			       v_cd_segurado,
			       v_dt_ocorrencia,
			       --
			       v_cd_cobertura_basica,
			       v_cd_cobertura_adicional,
			       v_cd_natureza_sinistro,
			       --
			       v_ds_endereco_risco,
			       v_nr_endereco_risco,
			       v_ds_compl_endereco_risco,
			       v_nm_cidade_risco,
			       v_id_uf_risco
			  from asw0016_aviso_sinst_re_sgrdo a
			 where a.id_aviso_sinst_re_sgrdo =
			       p_id_aviso_sinst_re_sgrdo;
		exception
			when no_data_found then
				v_mens := 'Não existe o registro ' ||
					  p_id_aviso_sinst_re_sgrdo ||
					  ' na tabela ASW0016_AVISO_SINST_RE_SGRDO.';
				raise v_saida_anormal;
			when others then
				v_mens := 'Problemas ao consultar tabela ASW0016_AVISO_SINST_RE_SGRDO. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
		--
		--
		begin
			select a.cd_reclamacao_elementar
			  into v_cd_aviso
			  from sinistro_reclamacao_eleme a,
			       sin_apolice               b,
			       sin_apolice_item_imovel   c
			 where a.id_ramo_produto_tmsr = b.cd_ramo_produto
			   and a.id_apolice_tmsr = b.cd_apolice
			   and a.id_endosso_tmsr = b.cd_endosso
			   and a.id_tipo_endosso_tmsr = b.cd_tipo_endosso
			   and b.cd_ramo_produto = c.cd_ramo_produto
			   and b.cd_apolice = c.cd_apolice
			   and b.cd_endosso = c.cd_endosso
			   and b.cd_tipo_endosso = c.cd_tipo_endosso
			   and a.id_item_tmsr = c.cd_item_apolice
			   and b.cd_segurado = v_cd_segurado
			   and a.dt_ocorrencia = v_dt_ocorrencia
			   and a.cd_natureza_sinistro =
			       v_cd_natureza_sinistro
			   and (b.cd_cia_seguradora = v_cd_cia_seguradora and
			       b.cd_ramo_produto = v_cd_ramo_apolice and
			       b.cd_apolice = v_cd_apolice and
			       b.cd_endosso = v_cd_endosso and
			       b.cd_tipo_endosso = v_cd_tipo_endosso and
			       c.cd_item_apolice = v_cd_item_apolice)
			   and (a.cd_cobertura_basica =
			       v_cd_cobertura_basica and
			       nvl(a.cd_cobertura_adicional, 0) =
			       nvl(v_cd_cobertura_adicional, 0))
			   and (nvl(c.ds_endereco_local_risco, 0) =
			       nvl(v_ds_endereco_risco, 0) and
			       nvl(c.nr_endereco_risco, 0) =
			       nvl(v_nr_endereco_risco, 0) and
			       nvl(c.ds_complemento_ender_risco, 0) =
			       nvl(v_ds_compl_endereco_risco, 0) and
			       nvl(c.nm_municipio_local_risco, 0) =
			       nvl(v_nm_cidade_risco, 0) and
			       nvl(c.id_uf_local_risco, 0) =
			       nvl(v_id_uf_risco, 0));
		exception
			when too_many_rows then
				begin
					select a.cd_reclamacao_elementar
					  into v_cd_aviso
					  from sinistro_reclamacao_eleme a,
					       sin_apolice               b,
					       sin_apolice_item_imovel   c
					 where a.id_ramo_produto_tmsr =
					       b.cd_ramo_produto
					   and a.id_apolice_tmsr =
					       b.cd_apolice
					   and a.id_endosso_tmsr =
					       b.cd_endosso
					   and a.id_tipo_endosso_tmsr =
					       b.cd_tipo_endosso
					   and b.cd_ramo_produto =
					       c.cd_ramo_produto
					   and b.cd_apolice = c.cd_apolice
					   and b.cd_endosso = c.cd_endosso
					   and b.cd_tipo_endosso =
					       c.cd_tipo_endosso
					   and a.id_item_tmsr =
					       c.cd_item_apolice
					   and b.cd_segurado =
					       v_cd_segurado
					   and a.dt_ocorrencia =
					       v_dt_ocorrencia
					   and a.cd_natureza_sinistro =
					       v_cd_natureza_sinistro
					   and (b.cd_cia_seguradora =
					       v_cd_cia_seguradora and
					       b.cd_ramo_produto =
					       v_cd_ramo_apolice and
					       b.cd_apolice = v_cd_apolice and
					       b.cd_endosso = v_cd_endosso and
					       b.cd_tipo_endosso =
					       v_cd_tipo_endosso and
					       c.cd_item_apolice =
					       v_cd_item_apolice)
					   and (a.cd_cobertura_basica =
					       v_cd_cobertura_basica and
					       nvl(a.cd_cobertura_adicional,
						    0) = nvl(v_cd_cobertura_adicional,
							      0))
					   and (nvl(c.ds_endereco_local_risco,
						    0) =
					       nvl(v_ds_endereco_risco, 0) and
					       nvl(c.nr_endereco_risco, 0) =
					       nvl(v_nr_endereco_risco, 0) and
					       nvl(c.ds_complemento_ender_risco,
						    0) = nvl(v_ds_compl_endereco_risco,
							      0) and
					       nvl(c.nm_municipio_local_risco,
						    0) =
					       nvl(v_nm_cidade_risco, 0) and
					       nvl(c.id_uf_local_risco, 0) =
					       nvl(v_id_uf_risco, 0))
					   and rownum = 1;
				exception
					when others then
						v_ds_retorno := 'J existe mais de um Aviso aberto para esse mesmo cadastro.';
						return v_ds_retorno;
				end;
			when others then
				v_ds_retorno := 'J existe Aviso aberto para esse mesmo cadastro.';
				return v_ds_retorno;
		end;
		--
		--
		if v_cd_aviso is not null then
			--
			v_ds_retorno := 'J existe o Aviso ' || v_cd_aviso ||
					' aberto para esse mesmo cadastro.';
			--
		else
			v_ds_retorno := null;
		end if;
		--
		--
		return v_ds_retorno;
		--
	exception
		when v_saida_anormal then
			v_ds_retorno := v_mens;
			return v_ds_retorno;
		when others then
			v_ds_retorno := null;
			return v_ds_retorno;
	end fnc_finaliza_aviso_re;
	--
	/***********************************************************************************
        prc_finaliza_aviso_re
        Author  : Michael Dossa
        Created : 13/04/2012
        Purpose : Rotina responsavel por finalizar aviso re.
        ***********************************************************************************/
	procedure prc_finaliza_aviso_re(p_id_aviso_sinst_re_sgrdo in out number,
					--up_id_aviso_sinst_re_sgrdo   in        out   number,
					p_mens out varchar2) is
		cursor c1 is
			select *
			  from asw0016_aviso_sinst_re_sgrdo
			 where id_aviso_sinst_re_sgrdo =
			       p_id_aviso_sinst_re_sgrdo;
		cursor c2 is
			select *
			  from asw0017_terceiro_re
			 where id_aviso_sinst_re_sgrdo =
			       p_id_aviso_sinst_re_sgrdo;

		cursor c3 (nr_aviso number)is
			select *
			from ASW0024_AVISO_SINST_RE_VEIC
			where cd_reclamacao_elementar = nr_aviso;

		cursor c4 (nr_aviso number, max_id number) is
			select *
			from SINISTRO_RECLAMACAO_ELEME_VEIC
			where cd_reclamacao_elementar = nr_aviso
			and id_veiculo > max_id;

		cursor	c5	is
		select	*
		from	asw0025_aviso_sinst_re_cober
		where	id_aviso_sinst_re_sgrdo	=	p_id_aviso_sinst_re_sgrdo;

		--
		v_rec_asw24			c3%rowtype;
		v_rec_srev			c4%rowtype;
		--
		v_lixo_date                   date := null;
		v_count                       number := null;
		v_id_tipo_operacao            number := null;
		v_cd_funcionario              number := null;
		v_cd_analista_sinistro        number := null;
		v_cd_corretor                 number := null;
		v_id_ramo_produto_tmsr        number := null;
		v_id_apolice_tmsr             number := null;
		v_id_tipo_endosso_tmsr        number := null;
		v_id_endosso_tmsr             number := null;
		v_id_item_tmsr                number := null;
		v_cd_produto_tmsr             number := null;
		v_id_sistema_origem           number := null;
		v_cd_local                    number := null;
		v_cd_ramo_apolice             number := null;
		v_cd_apolice                  number := null;
		v_cd_item_apolice             number := null;
		v_cd_endosso                  number := null;
		v_cd_produto                  number := null;
		v_cd_produto_historico        number := null;
		v_cd_produto_arquivo          number := null;
		v_ds_cobertura                number := null;
		v_vl_importancia_segurada     number := null;
		v_cd_cobertura                number := null;
		v_cd_endereco_segurado_tela   number := null;
		v_nr_ddd_segurado_tela        number := null;
		v_id_cep_segurado_tela        number := null;
		v_cd_reclamacao_elementar     number := null;
		v_cd_sub_local                number := null;
		v_st_registro                 number := null;
		v_cd_vistoriador_sinistro     number := null;
		v_cd_sinistro                 number := null;
		v_aviso_sem_apolice           number := null;
		v_cd_local_contabil           number := null;
		v_cd_reclamante_sinistro      number := 1;
		v_lixo_number                 number := null;
		v_id_situacao                 number := 1;
		v_id_dados_riscos_digitais    varchar2(1) := null;
		v_nm_segurado                 varchar2(1000) := null;
		v_ds_natureza                 varchar2(1000) := null;
		v_ds_endereco_segurado_tela   varchar2(1000) := null;
		v_nr_endereco_segurado_tela   varchar2(1000) := null;
		v_nm_complemento_segur_tela   varchar2(1000) := null;
		v_nm_bairro_segurado_tela     varchar2(1000) := null;
		v_nm_municipio_segurado_tela  varchar2(1000) := null;
		v_id_unida_feder_segur_tela   varchar2(1000) := null;
		v_ds_unida_feder_segur_tela   varchar2(1000) := null;
		v_id_situacao_abertura        varchar2(1000) := null;
		v_lixo_varchar                varchar2(1000) := null;
		v_ds_produto                  varchar2(500) := null;
		v_id_origem                   varchar2(1) := null;
		v_id_existe_email_corretor    varchar2(1) := null;
		v_id_achou_apolice            varchar2(1) := null;
		v_cd_letra_sinistro           varchar2(2) := null;
		v_operacao                    varchar2(1) := 'I';
		v_id_terceiro                 varchar2(1) := 'N';
		v_vl_estimativa_prejuizo      number(15, 2) := null;
		v_vl_maximo                   number(15, 2) := null;
		v_id_necessidade_vistoria     varchar2(1) := 'N';
		v_cd_terceiro_sinistro        number := null;
		v_cpf_cnpj_terceiro           number := null;
		v_digito_terceiro             number := null;
		v_estabelecimento_terceiro    number := null;
		v_cd_terceiro_sinistro_eleme  number := null;
		v_cd_cidade_vistoria          number := null;
		v_ddd_contato_contato         number := null;
		v_tel_contato_contato         number := null;
		v_ddd_contato_comunicante     number := null;
		v_tel_contato_comunicante     number := null;
		v_id_email_analista           varchar2(50) := null;
		v_nm_vistoriador_sinistro     varchar2(80) := null;
		v_id_email_vistoriador        varchar2(200) := null;
		v_nm_segurado_individual      varchar2(80) := null;
		v_nr_cgc_cpf_segurado         number := null;
		v_nr_estabelecimento_segurado number := null;
		v_digito_verificador          number := null;
		v_vl_estimativa_utilizada     number(15, 2) := null;
		v_vl_valor_is_original        number(15, 2) := null;
		v_vl_valor_minimo_abertura_os number(15, 2) := null;
		v_id_alerta_vl_min_abert_os   varchar(1) := null;
		v_saida_anormal exception;
		v_id_comun_sabe_valor          varchar2(1) := null;
		v_vl_referencia_contact_center number := null;
		v_vl_estimativa_padrao_min     number := null;
		v_vl_estimativa_padrao_max     number := null;
		v_vl_vistoria_gm               number := null;
		v_vl_est_calculada             number;
		v_vl_is_atual                  number;
		v_is_primeiro_reparo           boolean;
		v_id_aplica_perc_is_prim_sin   varchar2(1);
		--
		--##(SS-1420) variaveis do e-mail com checklist rc ambiental ##
		vrc_ds_observacao              varchar2(4000) := null;
		vrc_id_email_segurado          varchar2(1000) := null;
		vrc_dt_ocorrencia              varchar2(100) := null;
		vrc_nm_informante_reclamacao   varchar2(1000) := null;
		vrc_nm_segurado                varchar2(1000) := null;
		vrc_nr_cgc_cpf_segurado        varchar2(100) := null;
		vrc_nr_estab_segurado          varchar2(100) := null;
		vrc_nr_digito_verificador      varchar2(100) := null;
		vrc_nr_ddd_segurado            varchar2(100) := null;
		vrc_nr_telefone_segurado       varchar2(100) := null;
		vrc_ds_local_ocorrencia        varchar2(4000) := null;
		vrc_nm_bairro_ocorrencia       varchar2(1000) := null;
		vrc_nm_municipio_ocorrencia    varchar2(1000) := null;
		vrc_id_unidade_federacao_ocorr varchar2(100) := null;
		vrc_ds_ocorrencia              varchar2(4000) := null;
		vrc_cd_benefsinis_assistencia  varchar2(1000) := null;
		vrc_nm_beneficiario            varchar2(1000) := null;
		vrc_id_email                   varchar2(1000) := null;
		vrc_nm_outro_prest_assistencia varchar2(1000) := null;
		vrc_id_email_prest_assistencia varchar2(1000) := null;
		vrc_destinatario               varchar2(1000) := null;
		vrc_retorno                    varchar2(1000) := null;
		vrc_msg                        varchar2(1000) := null;
		vcr_noapolice                  varchar2(100) := null;
		--
		v_liga				varchar2(1);
		--
		v_cd_tipo_vistoria_sinistro	number(2) := null;
		v_insere			boolean := true;
		v_number_null			number := null;
		v_varchar_null			varchar2(1) := null;
		v_dt_atual			date := sysdate;
		v_cia_segur			number := 6190;
		v_rowcount			number;
		v_cd_veiculo_anterior		number;
		v_veiculo_anterior		varchar2(1000):=null;
		v_veiculo_atual			varchar2(1000):=null;
		v_causa_anterior		varchar2(1000):=null;
		v_causa_atual			varchar2(1000):=null;
		--
		v_ds_natureza_atual		varchar2(1000):=null;
		v_ds_natureza_anterior		varchar2(1000):=null;
		v_cd_tipo_bem_segurado		number:=null;
		v_cd_caracteristica_bem_segur	number:=null;
		v_cd_ramo			number:=null;
		v_sinistro_gerado		boolean:= true;
		v_gerado_sinistro		varchar2(1) := 'S';
		--
		v_existe_checklist		varchar2(1);-- SSIN 3786: FIANÇA CHECKLIST
		v_cd_checklist			number;-- SSIN 3786: FIANÇA CHECKLIST
		--
    v_nm_analista_sinistro		varchar2(400) := null;
    v_cd_grupo_analista		    number 	      := 0;
    v_ds_grupo_analista		    varchar2(400) := null;
    p_ds_fase                 varchar2(400) := null;
    p_id_log_erro             number;


	begin

		if p_id_aviso_sinst_re_sgrdo is null then
			p_mens := 'Parametro P_ID_AVISO_SINST_RE_SGRDO não recebido.';
			raise v_saida_anormal;
		end if;
		--verifica se o registro existe
		begin
			v_count := 0;
			select count(1)
			  into v_count
			  from asw0016_aviso_sinst_re_sgrdo asw0016
			 where asw0016.id_aviso_sinst_re_sgrdo =
			       p_id_aviso_sinst_re_sgrdo;
		exception
			when others then
				p_mens := 'Problemas ao consultar tabela ASW0016_AVISO_SINST_RE_SGRDO. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
		--
		if v_count <> 1 then
			p_mens := 'Não existe o registro ' ||
				  p_id_aviso_sinst_re_sgrdo ||
				  ' na tabela ASW0016_AVISO_SINST_RE_SGRDO.';
			raise v_saida_anormal;
		end if;
		--
		for r1 in c1 loop

			if r1.nr_aviso is not null then
				v_cd_reclamacao_elementar := r1.nr_aviso;
				-- if	r1.id_tipo_recepcao	<>	16	then	--SinistroDigitalResidencial
                if r1.id_tipo_recepcao <> 16 AND r1.id_tipo_recepcao <> 22 then --SinistroDigitalResidencial, OpinAviso
					v_insere := false;
				end	if;
				begin
					-- select	id_situacao,
					-- 	sre.cd_analista_sinistro
					-- into	v_id_situacao,
					-- 	v_cd_analista_sinistro
					-- from	sinistro_reclamacao_eleme sre
					-- where	sre.cd_reclamacao_elementar = v_cd_reclamacao_elementar;
                    
                    select sre.id_situacao, sre.cd_analista_sinistro, sre.cd_funcionario
                    into v_id_situacao, v_cd_analista_sinistro, v_cd_funcionario
                    from sinistro_reclamacao_eleme sre
                    where sre.cd_reclamacao_elementar = v_cd_reclamacao_elementar;

				exception
					when	no_data_found	then
						v_id_situacao := 1;
					when	others	then
						p_mens	:=	'Falha ao recuperar id_situacao da sinistro_reclamacao_eleme. Aviso: ' || v_cd_reclamacao_elementar ||
						' erro: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				--
			end if;

			if r1.ID_NECESSIDADE_VISTORIA is not null then
				v_id_necessidade_vistoria := r1.ID_NECESSIDADE_VISTORIA;
			end if;

			if r1.CD_VISTORIADOR_SINISTRO is not null then
				v_cd_vistoriador_sinistro := r1.CD_VISTORIADOR_SINISTRO;
			end if;

			if r1.cd_tipo_vistoria_sinistro IS NOT NULL THEN
				v_cd_tipo_vistoria_sinistro := r1.cd_tipo_vistoria_sinistro;
			end if;

			if r1.nr_telef_comrl_contt is null then
				v_ddd_contato_contato := r1.nr_ddd_celul_contt;
				v_tel_contato_contato := r1.nr_telef_celul_contt;
			else
				v_ddd_contato_contato := r1.nr_telef_comrl_contt;
				v_tel_contato_contato := r1.nr_ddd_comrl_contt;
			end if;
			if r1.nr_telef_comrl_comnt is null then
				v_ddd_contato_comunicante := r1.nr_ddd_celul_comnt;
				v_tel_contato_comunicante := r1.nr_telef_celul_comnt;
			else
				v_ddd_contato_comunicante := r1.nr_ddd_telef_comrl_comnt;
				v_tel_contato_comunicante := r1.nr_telef_comrl_comnt;
			end if;
			--
			v_id_achou_apolice       := 'N';
			v_nm_segurado_individual := r1.nm_sgrdo_individual;
			if r1.cd_tipo_sgrdo = 'F' then
				v_nr_cgc_cpf_segurado := substr(r1.nr_cpf_cnpj_sgrdo,
								0,
								length(r1.nr_cpf_cnpj_sgrdo) - 2);
				v_digito_verificador  := substr(r1.nr_cpf_cnpj_sgrdo,
								length(r1.nr_cpf_cnpj_sgrdo) - 1,
								length(r1.nr_cpf_cnpj_sgrdo));
			else
				v_nr_cgc_cpf_segurado         := substr(r1.nr_cpf_cnpj_sgrdo,
									0,
									length(r1.nr_cpf_cnpj_sgrdo) - 6);
				v_nr_estabelecimento_segurado := substr(r1.nr_cpf_cnpj_sgrdo,
									length(r1.nr_cpf_cnpj_sgrdo) - 5,
									4);
				v_digito_verificador          := substr(r1.nr_cpf_cnpj_sgrdo,
									length(r1.nr_cpf_cnpj_sgrdo) - 1,
									length(r1.nr_cpf_cnpj_sgrdo));
			end if;
			--begin
			if r1.cd_apoli is not null then
				v_id_achou_apolice := 'S';
			else
				--Alterao para caso de Aviso RE Afinidades sem aplice.
				v_ds_endereco_segurado_tela  := r1.nm_logra_loc_risco;
				v_id_unida_feder_segur_tela  := r1.sg_unidd_fedrc_loc_risco;
				v_nm_bairro_segurado_tela    := 'Não SE APLICA';
				v_nm_complemento_segur_tela  := r1.ds_cmplo_loc_risco;
				v_nm_municipio_segurado_tela := r1.nm_cidad_loc_risco;
				v_nr_ddd_segurado_tela       := nvl(r1.nr_ddd_celul_sgrdo,r1.nr_ddd_telef_resdl_sgrdo);
				v_nr_endereco_segurado_tela  := r1.nr_logra_loc_risco;
				v_nm_segurado                := r1.nm_sgrdo;
				v_id_sistema_origem          := 2;
			end if;
			--verifica tipo operacao
			begin
				v_id_tipo_operacao := sini7070_007.fnc_recupera_tipo_operacao(r1.cd_tipo_bem_segrdo,
											      r1.cd_carac_bem_segrdo,
											      r1.cd_ramo_cobertura,
											      p_mens);
			exception
				when others then
					p_mens := 'Problemas ao tentar executar SINI7070_007.FNC_RECUPERA_TIPO_OPERACAO Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			if p_mens is not null then
				raise v_saida_anormal;
			end if;
			--
			if v_id_achou_apolice = 'S' then
				if r1.cd_tipo_bem_segrdo = 1 then
					p_mens := 'Ramo de automvel. Favor realizar a abertura pela tela de aviso de sinistro de automvel.';
					raise v_saida_anormal;
				elsif r1.cd_tipo_bem_segrdo = 3 then
					p_mens := 'Ramo de vida. Favor realizar a abertura pela tela de aviso de sinistro de vida.';
					raise v_saida_anormal;
				elsif r1.cd_tipo_bem_segrdo = 2 then
					--IMVEL
					if r1.cd_cia_sgdra =
					   global_cd_cia_seguradora then
						begin
							select 'X',
							       sa.cd_sistema_origem,
							       sa.cd_ramo_produto,
							       sa.cd_apolice,
							       sa.cd_endosso,
							       sa.cd_tipo_endosso,
							       sai.cd_item_apolice,
							       sair.cd_produto
							  into v_id_origem,
							       v_id_sistema_origem,
							       v_id_ramo_produto_tmsr,
							       v_id_apolice_tmsr,
							       v_id_endosso_tmsr,
							       v_id_tipo_endosso_tmsr,
							       v_id_item_tmsr,
							       v_cd_produto_tmsr
							  from sin_apolice             sa,
							       sin_apolice_item        sai,
							       sin_apolice_item_imovel saii,
							       sin_apolice_item_ramo   sair
							 where sa.cd_companhia_segur_emissao =
							       sai.cd_companhia_segur_emissao
							   and sa.cd_ramo_produto =
							       sai.cd_ramo_produto
							   and sa.cd_apolice =
							       sai.cd_apolice
							   and sa.cd_endosso =
							       sai.cd_endosso
							   and sa.cd_tipo_endosso =
							       sai.cd_tipo_endosso
							   and sai.cd_companhia_segur_emissao =
							       saii.cd_companhia_segur_emissao
							   and sai.cd_ramo_produto =
							       saii.cd_ramo_produto
							   and sai.cd_apolice =
							       saii.cd_apolice
							   and sai.cd_endosso =
							       saii.cd_endosso
							   and sai.cd_tipo_endosso =
							       saii.cd_tipo_endosso
							   and sai.cd_item_apolice =
							       saii.cd_item_apolice
							   and sai.cd_companhia_segur_emissao =
							       sair.cd_companhia_segur_emissao
							   and sai.cd_ramo_produto =
							       sair.cd_ramo_produto
							   and sai.cd_apolice =
							       sair.cd_apolice
							   and sai.cd_endosso =
							       sair.cd_endosso
							   and sai.cd_tipo_endosso =
							       sair.cd_tipo_endosso
							   and sai.cd_item_apolice =
							       sair.cd_item_apolice
							   and sai.cd_companhia_segur_emissao =
							       r1.cd_cia_sgdra
							   and sai.cd_ramo_produto =
							       r1.cd_ramo_apoli
							   and sai.cd_apolice =
							       r1.cd_apoli
							   and sai.cd_endosso =
							       r1.cd_endos
							   and sai.cd_tipo_endosso =
							       r1.cd_tipo_endos
							   and sai.cd_item_apolice =
							       r1.cd_item_apoli
							   and sair.cd_produto =
							       r1.cd_prdut;
						exception
							when no_data_found then
								p_mens := '2 - X - Aplice ' ||
									  r1.cd_cia_sgdra || ' ' ||
									  r1.cd_ramo_apoli || ' ' ||
									  r1.cd_apoli || ' ' ||
									  r1.cd_tipo_endos || ' ' ||
									  r1.cd_endos ||
									  ' item ' ||
									  r1.cd_item_apoli ||
									  ' não localizada na base.';
								raise v_saida_anormal;
							when others then
								p_mens := '2 - X - Problemas ao tentar recuperar dados da aplice ' ||
									  r1.cd_cia_sgdra || ' ' ||
									  r1.cd_ramo_apoli || ' ' ||
									  r1.cd_apoli || ' ' ||
									  r1.cd_tipo_endos || ' ' ||
									  r1.cd_endos ||
									  ' item ' ||
									  r1.cd_item_apoli ||
									  '. Erro: ' ||
									  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;
						end;

						/*-- SinistroDigitalResidencial
						if	r1.nm_cidad_loc_sinis		is	null	then

							begin
								select	s.ds_complemento_caracteristica
								into	v_nm_municipio_ocorr
								from	sin_apoli_imovel_detalhe 	s
								where	s.cd_companhia_segur_emissao	=	r1.cd_cia_sgdra
								and	s.cd_ramo_produto		=	r1.cd_ramo_apoli
								and	s.cd_apolice			=	r1.cd_apoli
								and	s.cd_tipo_endosso		=	r1.cd_tipo_endos
								and	s.cd_endosso			=	r1.cd_endos
								and	s.cd_item_apolice		=	r1.cd_item_apoli
								and	s.ds_caracteristica		in	('UF - CIDADE','CIDADE LOCAL DE RISCO')
								and	rownum	<	1;
							exception
								when	others	then
									v_nm_municipio_ocorr	:=	null;
							end;
							--

							begin
								select	s.ds_complemento_caracteristica
								into	v_id_unidade_federacao_ocorr
								from	sin_apoli_imovel_detalhe 	s
								where	s.cd_companhia_segur_emissao	=	r1.cd_cia_sgdra
								and	s.cd_ramo_produto		=	r1.cd_ramo_apoli
								and	s.cd_apolice			=	r1.cd_apoli
								and	s.cd_tipo_endosso		=	r1.cd_tipo_endos
								and	s.cd_endosso			=	r1.cd_endos
								and	s.cd_item_apolice		=	r1.cd_item_apoli
								and	s.ds_caracteristica		in	('SIGLA DO ESTADO','ESTADO LOCAL DE RISCO')
								and	rownum	<	1;
							exception
								when	others	then
									v_id_unidade_federacao_ocorr	:=	null;
							end;
						end	if;
						*/
					else
						p_mens := '2 - Companhia ' ||
							  r1.cd_cia_sgdra ||
							  ' inválida para abertura de aviso de sinistro.';
						raise v_saida_anormal;
					end if;
				elsif r1.cd_tipo_bem_segrdo = 4 then
					--RISCOS DIVERSOS
					if r1.cd_cia_sgdra =
					   global_cd_cia_seguradora then
						begin
							select 'X',
							       sa.cd_sistema_origem,
							       sa.cd_ramo_produto,
							       sa.cd_apolice,
							       sa.cd_endosso,
							       sa.cd_tipo_endosso,
							       sai.cd_item_apolice,
							       sair.cd_produto
							  into v_id_origem,
							       v_id_sistema_origem,
							       v_id_ramo_produto_tmsr,
							       v_id_apolice_tmsr,
							       v_id_endosso_tmsr,
							       v_id_tipo_endosso_tmsr,
							       v_id_item_tmsr,
							       v_cd_produto_tmsr
							  from sin_apolice                  sa,
							       sin_apolice_item             sai,
							       sin_apolice_item_risco_diver saird,
							       sin_apolice_item_ramo        sair
							 where sa.cd_companhia_segur_emissao =
							       sai.cd_companhia_segur_emissao
							   and sa.cd_ramo_produto =
							       sai.cd_ramo_produto
							   and sa.cd_apolice =
							       sai.cd_apolice
							   and sa.cd_endosso =
							       sai.cd_endosso
							   and sa.cd_tipo_endosso =
							       sai.cd_tipo_endosso
							   and sai.cd_companhia_segur_emissao =
							       saird.cd_companhia_segur_emissao
							   and sai.cd_ramo_produto =
							       saird.cd_ramo_produto
							   and sai.cd_apolice =
							       saird.cd_apolice
							   and sai.cd_endosso =
							       saird.cd_endosso
							   and sai.cd_tipo_endosso =
							       saird.cd_tipo_endosso
							   and sai.cd_item_apolice =
							       saird.cd_item_apolice
							   and sai.cd_companhia_segur_emissao =
							       sair.cd_companhia_segur_emissao
							   and sai.cd_ramo_produto =
							       sair.cd_ramo_produto
							   and sai.cd_apolice =
							       sair.cd_apolice
							   and sai.cd_endosso =
							       sair.cd_endosso
							   and sai.cd_tipo_endosso =
							       sair.cd_tipo_endosso
							   and sai.cd_item_apolice =
							       sair.cd_item_apolice
							   and sai.cd_companhia_segur_emissao =
							       r1.cd_cia_sgdra
							   and sai.cd_ramo_produto =
							       r1.cd_ramo_apoli
							   and sai.cd_apolice =
							       r1.cd_apoli
							   and sai.cd_endosso =
							       r1.cd_endos
							   and sai.cd_tipo_endosso =
							       r1.cd_tipo_endos
							   and sai.cd_item_apolice =
							       r1.cd_item_apoli
							   and sair.cd_produto =
							       r1.cd_prdut;
						exception
							when no_data_found then
								p_mens := '4 - Aplice ' ||
									  r1.cd_cia_sgdra || ' ' ||
									  r1.cd_ramo_apoli || ' ' ||
									  r1.cd_apoli || ' ' ||
									  r1.cd_tipo_endos || ' ' ||
									  r1.cd_endos ||
									  ' item ' ||
									  r1.cd_item_apoli ||
									  ' não localizada na base.';
								raise v_saida_anormal;
							when others then
								p_mens := '4 - Problemas ao tentar recuperar dados da aplice ' ||
									  r1.cd_cia_sgdra || ' ' ||
									  r1.cd_ramo_apoli || ' ' ||
									  r1.cd_apoli || ' ' ||
									  r1.cd_tipo_endos || ' ' ||
									  r1.cd_endos ||
									  ' item ' ||
									  r1.cd_item_apoli ||
									  '. Erro: ' ||
									  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;
						end;

					else
						p_mens := '4 - Companhia ' ||
							  r1.cd_cia_sgdra ||
							  ' inválida para abertura de aviso de sinistro.';
						raise v_saida_anormal;
					end if;
				elsif r1.cd_tipo_bem_segrdo = 5 then
					--DEMAIS
					if r1.cd_cia_sgdra = 6190 then
						begin
							select 'X',
							       sa.cd_sistema_origem,
							       sa.cd_ramo_produto,
							       sa.cd_apolice,
							       sa.cd_endosso,
							       sa.cd_tipo_endosso,
							       sai.cd_item_apolice,
							       sair.cd_produto
							  into v_id_origem,
							       v_id_sistema_origem,
							       v_id_ramo_produto_tmsr,
							       v_id_apolice_tmsr,
							       v_id_endosso_tmsr,
							       v_id_tipo_endosso_tmsr,
							       v_id_item_tmsr,
							       v_cd_produto_tmsr
							  from sin_apolice             sa,
							       sin_apolice_item        sai,
							       sin_apolice_item_demais said,
							       sin_apolice_item_ramo   sair
							 where sa.cd_companhia_segur_emissao =
							       sai.cd_companhia_segur_emissao
							   and sa.cd_ramo_produto =
							       sai.cd_ramo_produto
							   and sa.cd_apolice =
							       sai.cd_apolice
							   and sa.cd_endosso =
							       sai.cd_endosso
							   and sa.cd_tipo_endosso =
							       sai.cd_tipo_endosso
							   and sai.cd_companhia_segur_emissao =
							       said.cd_companhia_segur_emissao
							   and sai.cd_ramo_produto =
							       said.cd_ramo_produto
							   and sai.cd_apolice =
							       said.cd_apolice
							   and sai.cd_endosso =
							       said.cd_endosso
							   and sai.cd_tipo_endosso =
							       said.cd_tipo_endosso
							   and sai.cd_item_apolice =
							       said.cd_item_apolice
							   and sai.cd_companhia_segur_emissao =
							       sair.cd_companhia_segur_emissao
							   and sai.cd_ramo_produto =
							       sair.cd_ramo_produto
							   and sai.cd_apolice =
							       sair.cd_apolice
							   and sai.cd_endosso =
							       sair.cd_endosso
							   and sai.cd_tipo_endosso =
							       sair.cd_tipo_endosso
							   and sai.cd_item_apolice =
							       sair.cd_item_apolice
							   and sai.cd_companhia_segur_emissao =
							       r1.cd_cia_sgdra
							   and sai.cd_ramo_produto =
							       r1.cd_ramo_apoli
							   and sai.cd_apolice =
							       r1.cd_apoli
							   and sai.cd_endosso =
							       r1.cd_endos
							   and sai.cd_tipo_endosso =
							       r1.cd_tipo_endos
							   and sai.cd_item_apolice =
							       r1.cd_item_apoli
							   and sair.cd_produto =
							       r1.cd_prdut;
						exception
							when no_data_found then
								p_mens := '5 - Aplice ' ||
									  r1.cd_cia_sgdra || ' ' ||
									  r1.cd_ramo_apoli || ' ' ||
									  r1.cd_apoli || ' ' ||
									  r1.cd_tipo_endos || ' ' ||
									  r1.cd_endos ||
									  ' item ' ||
									  r1.cd_item_apoli ||
									  ' não localizada na base.';
								raise v_saida_anormal;
							when others then
								p_mens := '5 - Problemas ao tentar recuperar dados da aplice ' ||
									  r1.cd_cia_sgdra || ' ' ||
									  r1.cd_ramo_apoli || ' ' ||
									  r1.cd_apoli || ' ' ||
									  r1.cd_tipo_endos || ' ' ||
									  r1.cd_endos ||
									  ' item ' ||
									  r1.cd_item_apoli ||
									  '. Erro: ' ||
									  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;
						end;

					else
						p_mens := '5 - Companhia ' ||
							  r1.cd_cia_sgdra ||
							  ' inválida para abertura de aviso de sinistro.';
						raise v_saida_anormal;
					end if;
				else
					p_mens := 'Ramo desconhecido - Tipo de bem segurado = ' ||
						  r1.cd_tipo_bem_segrdo;
					raise v_saida_anormal;
				end if;
			end if;
			--
			v_id_comun_sabe_valor := 'S';
			--
			-- SinistroDigitalResidencial
			if	nvl(r1.id_valor_prej_informado,'X')	=	'N'	then
				v_id_comun_sabe_valor := 'N';
			end	if;
			--
			if r1.id_faixa_sinis is not null then
				begin
					select scfw.vl_adotado
					  into v_vl_estimativa_prejuizo
					  from sinistro_controle_faixa_web scfw
					 where scfw.id_sinistro_controle =
					       r1.id_faixa_sinis;
				exception
					when others then
						p_mens := 'Problemas ao tentar recuperar valor da faixa ' ||
							  r1.id_faixa_sinis ||
							  '. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				--
				if sini4000_025.fnc_existe_estimativa_padrao(v_id_ramo_produto_tmsr) then
					--
					v_id_comun_sabe_valor := 'N';
					--
					begin
						--
						sini4000_025.prc_retorna_valores_por_ramo(v_id_ramo_produto_tmsr,
											  v_vl_referencia_contact_center,
											  v_vl_estimativa_padrao_min,
											  v_vl_estimativa_padrao_max,
											  v_vl_vistoria_gm,
											  p_mens);
						--
					exception
						when others then
							p_mens := 'Problemas ao chamar SINI4000_025.PRC_RETORNA_VALORES_POR_RAMO. Erro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
					--
					if p_mens is not null then
						raise v_saida_anormal;
					end if;
					--
					if v_vl_estimativa_prejuizo <
					   v_vl_referencia_contact_center then
						v_vl_estimativa_prejuizo := v_vl_referencia_contact_center;
					else
						if v_vl_estimativa_prejuizo >
						   v_vl_estimativa_padrao_max then
							v_vl_estimativa_prejuizo := v_vl_estimativa_padrao_max;
						else
							v_vl_estimativa_prejuizo := v_vl_referencia_contact_center + 0.01;
						end if;
					end if;
					--
				end if;
			elsif r1.vl_estimativa_prejuizo is not null then


				begin
					select srvmw.vl_maximo
					  into v_vl_maximo
					  from sinistro_ramo_valor_maximo_web srvmw
					 where srvmw.cd_tipo_bem_segurado =
					       r1.cd_tipo_bem_segrdo
					   and srvmw.cd_caracteristica_bem_segur =
					       r1.cd_carac_bem_segrdo
					   and srvmw.cd_ramo =
					       r1.cd_ramo_cobertura;
				exception
					when others then
						p_mens := 'Problemas ao tentar recuperar o valor maximo para estimativa para o ramo - ' ||
							  r1.cd_tipo_bem_segrdo || ' ' ||
							  r1.cd_carac_bem_segrdo || ' ' ||
							  r1.cd_ramo_cobertura ||
							  '. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				--
				if r1.vl_estimativa_prejuizo > v_vl_maximo then
					v_vl_estimativa_prejuizo := v_vl_maximo;
				elsif r1.vl_estimativa_prejuizo < 0 then
					p_mens := 'Não é possivel abrir um aviso com a estimativa de prejuzo negativa.';
					raise v_saida_anormal;
				else
					v_vl_estimativa_prejuizo := r1.vl_estimativa_prejuizo;
				end if;
			end if;
			--
			v_lixo_varchar := null;
			v_lixo_date    := null;
			begin
				sini7070_006.sireel_dt_ocorrencia_wvi(v_id_origem,
								      --p_id_origem                in    out    varchar2
								      v_id_sistema_origem,
								      --p_id_sistema_origem            in    out    number
								      r1.cd_cia_sgdra,
								      --p_cd_cia_seguradora_aux        in    out    number
								      r1.cd_tipo_bem_segrdo,
								      --p_cd_tipo_bem_segurado        in        number
								      r1.cd_carac_bem_segrdo,
								      --p_cd_caracteristica_bem_segur    in        number
								      r1.cd_ramo_cobertura,
								      --p_cd_ramo                in        number
								      v_cd_local,
								      --p_cd_local                in    out    number
								      v_cd_apolice,
								      --p_cd_apolice                in    out    number
								      v_cd_ramo_apolice,
								      --p_cd_ramo_apolice            in    out    number
								      r1.dt_arquv,
								      --p_dt_historico_arquivo        in    out    date
								      r1.dt_inico_vigen,
								      --p_dt_inicio_vigencia            in    out    date
								      r1.dt_termn_vigen,
								      --p_dt_termino_vigencia        in    out    date
								      r1.dt_ocorrencia,
								      --p_dt_ocorrencia            in        date
								      v_id_apolice_tmsr,
								      --p_id_apolice_tmsr            in    out    number
								      v_id_endosso_tmsr,
								      --p_id_endosso_tmsr            in    out    number
								      v_id_ramo_produto_tmsr,
								      --p_id_ramo_produto_tmsr        in    out    number
								      v_id_tipo_endosso_tmsr,
								      --p_id_tipo_endosso_tmsr        in    out    number
								      'N',
								      --p_id_rollout                in        varchar2
								      v_id_tipo_operacao,
								      --p_id_tipo_operacao            in        number
								      r1.cd_cia_sgdra,
								      --p_cd_cia_seguradora            in    out    number
								      v_cd_item_apolice,
								      --p_cd_item_apolice            in    out    number
								      r1.cd_endos,
								      --p_cd_endosso                in    out    number
								      r1.cd_prdut,
								      --p_id_produto                in    out    number
								      v_cd_produto,
								      --p_cd_produto                in    out    number
								      v_lixo_varchar,
								      --p_ds_produto                in    out    varchar2
								      v_cd_produto_arquivo,
								      --p_cd_produto_arquivo            in    out    number
								      v_cd_produto_historico,
								      --p_cd_produto_historico        in    out    number
								      v_id_item_tmsr,
								      --p_id_item_tmsr            in    out    number
								      r1.cd_sgrdo,
								      --p_cd_segurado_tela            in    out    number
								      r1.nm_sgrdo,
								      --p_nm_segurado_tela            in    out    varchar2
								      v_cd_endereco_segurado_tela,
								      --p_cd_endereco_segurado_tela        in    out    number
								      v_ds_endereco_segurado_tela,
								      --p_ds_endereco_segurado_tela        in    out    varchar2
								      v_nr_endereco_segurado_tela,
								      --p_nr_endereco_segurado_tela        in    out    varchar2
								      v_nm_complemento_segur_tela,
								      --p_nm_complemento_segur_tela        in    out    varchar2
								      v_id_cep_segurado_tela,
								      --p_id_cep_segurado_tela        in    out    number
								      v_nm_bairro_segurado_tela,
								      --p_nm_bairro_segurado_tela        in    out    varchar2
								      v_nm_municipio_segurado_tela,
								      --p_nm_municipio_segurado_tela        in    out    varchar2
								      v_id_unida_feder_segur_tela,
								      --p_id_unida_feder_segur_tela        in    out    varchar2
								      v_ds_unida_feder_segur_tela,
								      --p_ds_unida_feder_segur_tela        in    out    varchar2
								      r1.nr_ddd_telef_resdl_sgrdo,
								      --p_nr_ddd_segurado_tela        in    out    number
								      r1.nr_telef_resdl_sgrdo,
								      --p_nr_telefone_segurado_tela        in    out    number
								      r1.cd_crtor,
								      --p_cd_corretor            in    out    number
								      v_lixo_varchar,
								      --p_ds_mensagem_corretor        in    out    varchar2
								      v_id_existe_email_corretor,
								      --p_id_existe_email_corretor        in    out    varchar2
								      v_id_achou_apolice,
								      --p_id_achou_apolice            in    out    varchar2
								      v_cd_produto_tmsr,
								      --p_cd_produto_tmsr            in    out    number
								      null,
								      --p_aviso_sem_apolice            in        number
								      p_mens
								      --p_mens                    out    varchar2
								      );
			exception
				when others then
					p_mens := 'Problemas na chamada da rotina SINI7070_006.SIREEL_DT_OCORRENCIA_WVI. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			if p_mens is not null then
				raise v_saida_anormal;
			end if;
			if r1.cd_cobertura_adicional is not null or
			   r1.cd_cobertura_basica is not null or
			   r1.cd_cobertura_especial is not null or
			   r1.cd_cobertura_espec_especial is not null then
				r1.id_cober_sinis := nvl(r1.cd_cobertura_espec_especial,
							 nvl(r1.cd_cobertura_especial,
							     nvl(r1.cd_cobertura_adicional,
								 r1.cd_cobertura_basica)));
			end if;
			--
			begin
				select sn.ds_natureza_sinistro
				  into v_ds_natureza
				  from sinistro_natureza sn
				 where sn.cd_natureza_sinistro =
				       r1.id_tipo_ocorr_sinis;
			exception
				when others then
					v_ds_natureza := null;
			end;
			--
			-- RMZ SEM APOLICE
			if v_id_achou_apolice = 'S' then
				begin
					sini7070_006.p_valida_cobertura(r1.cd_cia_sgdra,
									--p_cd_cia_seguradora            in        number
									r1.cd_cia_sgdra,
									--p_cd_cia_seguradora_aux        in        number
									v_id_sistema_origem,
									--p_id_sistema_origem            in        number
									r1.cd_tipo_bem_segrdo,
									--p_cd_tipo_bem_segurado        in        number
									r1.cd_carac_bem_segrdo,
									--p_cd_caracteristica_bem_segur    in        number
									r1.cd_ramo_cobertura,
									--p_cd_ramo                in        number
									v_cd_apolice,
									--p_cd_apolice                in        number
									r1.cd_cobertura_basica,
									--p_cd_cobertura_basica        in        number
									r1.cd_cobertura_adicional,
									--p_cd_cobertura_adicional        in        number
									r1.cd_cobertura_especial,
									--p_cd_cobertura_especial        in        number
									r1.cd_cobertura_espec_especial,
									--p_cd_cober_espec_espec        in        number
									r1.id_cober_sinis,
									--p_cd_cobertura            in    out    number
									v_ds_cobertura,
									--p_ds_cobertura            in    out    varchar2
									v_id_apolice_tmsr,
									--p_id_apolice_tmsr            in        number
									v_id_tipo_endosso_tmsr,
									--p_id_tipo_endosso_tmsr        in        number
									v_id_endosso_tmsr,
									--p_id_endosso_tmsr            in        number
									v_id_item_tmsr,
									--p_id_item_tmsr            in        number
									v_id_ramo_produto_tmsr,
									--p_id_ramo_produto_tmsr        in        number
									r1.cd_sequencia_cobertura,
									--p_cd_sequencia            in        number
									p_mens
									--p_mens                    out    varchar2
									);
				exception
					when others then
						p_mens := 'Problemas na chamada da rotina SINI7070_006.P_VALIDA_COBERTURA. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				if p_mens is not null then
					raise v_saida_anormal;
				end if;
			end if;
			--
			v_lixo_varchar := null;
			v_lixo_date    := null;

			if v_insere then
				begin
					sini7070_006.pre_insert(r1.cd_cia_sgdra,
								--p_cd_cia_seguradora_aux        in        number
								v_cd_reclamacao_elementar,
								--p_cd_reclamacao_elementar        in    out    number
								r1.cd_cia_sgdra,
								--p_cd_cia_seguradora            in    out    number
								r1.cd_carac_bem_segrdo,
								--p_cd_caracteristica_bem_segur    in        number
								r1.cd_tipo_bem_segrdo,
								--p_cd_tipo_bem_segurado        in        number
								r1.cd_ramo_cobertura,
								--p_cd_ramo                in        number
								v_cd_item_apolice,
								--p_cd_item_apolice            in        number
								v_cd_local,
								--p_cd_local                in        number
								v_cd_apolice,
								--p_cd_apolice                in        number
								v_cd_produto,
								--p_cd_produto                in        number
								v_cd_produto_arquivo,
								--p_cd_produto_arquivo            in        number
								v_cd_produto_historico,
								--p_cd_produto_historico        in        number
								v_cd_ramo_apolice,
								--p_cd_ramo_apolice            in        number
								r1.dt_arquv,
								--p_dt_historico_arquivo        in        date
								v_id_apolice_tmsr,
								--p_id_apolice_tmsr            in        number
								v_id_tipo_endosso_tmsr,
								--p_id_tipo_endosso_tmsr        in        number
								v_id_endosso_tmsr,
								--p_id_endosso_tmsr            in        number
								v_id_item_tmsr,
								--p_id_item_tmsr            in        number
								v_id_ramo_produto_tmsr,
								--p_id_ramo_produto_tmsr        in        number
								v_cd_produto_tmsr,
								--p_cd_produto_tmsr            in        number
								v_vl_importancia_segurada,
								--p_vl_importancia_segurada        in    out    number
								v_cd_sub_local,
								--p_cd_sub_local            in    out    number
								v_ds_endereco_segurado_tela,
								--p_ds_endereco_segurado        in    out    varchar2
								v_id_achou_apolice,
								--p_id_achou_apolice            in    out    varchar2
								v_id_cep_segurado_tela,
								--p_id_cep_segurado            in    out    number
								v_id_unida_feder_segur_tela,
								--p_id_unidade_federacao_segur        in    out    varchar2
								v_nm_bairro_segurado_tela,
								--p_nm_bairro_segurado            in    out    varchar2
								v_nm_complemento_segur_tela,
								--p_nm_complemento_ender_segur        in    out    varchar2
								v_nm_municipio_segurado_tela,
								--p_nm_municipio_segurado        in    out    varchar2
								v_nm_segurado,
								--p_nm_segurado            in    out    varchar2
								v_nr_ddd_segurado_tela,
								--p_nr_ddd_segurado            in    out    number
								v_nr_endereco_segurado_tela,
								--p_nr_endereco_segurado        in    out    varchar2
								r1.nr_telef_resdl_sgrdo,
								--p_nr_telefone_segurado        in    out    number
								v_id_terceiro,
								--p_id_terceiro            in    out    varchar2
								v_lixo_number,
								--p_vl_estimativa_prejuizo        in    out    number
								v_id_situacao,
								--p_id_situacao            in    out    number
								v_lixo_varchar,
								--p_ds_situacao                out    varchar2
								v_lixo_date,
								--p_dt_inclusao                out    date
								v_lixo_varchar,
								--p_nm_usuario_inclusao            out    varchar2
								'N',
								--p_id_rollout                in        varchar2
								v_st_registro,
								--p_st_registro                out    number
								p_mens
								--p_mens                    out    varchar2*/
								);
				exception
					when others then
						p_mens := 'Problemas na chamada da rotina SINI7070_006.PRE_INSERT. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				if p_mens is not null then
					raise v_saida_anormal;
				end if;
			else
				--
				begin
					sini7070_006.pre_update(
						  p_cd_cia_seguradora => v_cia_segur
						, p_cd_cia_seguradora_aux => v_cia_segur
						, p_id_tipo_operacao => v_id_tipo_operacao
						, p_cd_caracteristica_bem_segur => r1.cd_carac_bem_segrdo
						, p_cd_tipo_bem_segurado => r1.cd_tipo_bem_segrdo
						, p_cd_ramo => r1.cd_ramo_cobertura
						, p_cd_local => v_cd_local
						, p_cd_local_copia => v_number_null
						, p_cd_ramo_apolice => v_cd_ramo_apolice
						, p_cd_produto => v_cd_produto
						, p_cd_produto_arquivo => v_cd_produto_arquivo
						, p_cd_produto_historico => v_cd_produto_historico
						, p_cd_apolice => v_cd_apolice
						, p_id_apolice_tmsr => v_id_apolice_tmsr
						, p_cd_produto_tmsr => v_cd_produto_tmsr
						, p_id_endosso_tmsr => v_id_endosso_tmsr
						, p_id_ramo_produto_tmsr => v_id_ramo_produto_tmsr
						, p_id_tipo_endosso_tmsr => v_id_tipo_endosso_tmsr
						, p_id_apolice_tmsr_copia => v_id_apolice_tmsr
						, p_cd_segurado_tela => r1.cd_sgrdo
						, p_cd_vistoriador_sinistro => v_cd_vistoriador_sinistro
						, p_cd_analista_sinistro => v_cd_analista_sinistro
						, p_cd_analista_old => v_number_null
						, p_cd_func_old => v_number_null
						, p_nm_analista_sinistro => v_varchar_null
						, p_nm_usuario_alteracao => r1.nm_usuro_alter
						, p_nr_ddd_analista => v_number_null
						, p_nr_telefone_analista => v_number_null
						, p_id_email_analista => v_number_null
						, p_retorna_grava => v_varchar_null
						, p_cd_reclamacao_elementar => v_cd_reclamacao_elementar
						, p_cd_cobertura => r1.cd_sequencia_cobertura
						, p_cd_funcionario => v_cd_funcionario
						, p_id_rollout => 'N'
						, p_id_situacao => v_id_situacao
						, p_dt_alteracao => v_dt_atual
						, p_vl_estimativa_prejuizo => r1.vl_estimativa_prejuizo
						, p_vl_importancia_segurada => v_vl_importancia_segurada
						, p_ds_endereco_segurado => v_ds_endereco_segurado_tela
						, p_id_achou_apolice => v_id_achou_apolice
						, p_id_cep_segurado => v_id_cep_segurado_tela
						, p_id_unidade_federacao_segur => v_id_unida_feder_segur_tela
						, p_nm_bairro_segurado => v_nm_bairro_segurado_tela
						, p_nm_complemento_ender_segur => v_nm_complemento_segur_tela
						, p_nm_municipio_segurado => v_nm_municipio_segurado_tela
						, p_nm_segurado => v_nm_segurado --r1.nm_sgrdo
						, p_nr_ddd_segurado => r1.nr_ddd_celul_sgrdo
						, p_nr_endereco_segurado => v_nr_endereco_segurado_tela
						, p_nr_telefone_segurado => r1.nr_telef_celul_sgrdo
						, p_cd_cidade_vistoria => v_cd_cidade_vistoria
						, p_ds_endereco_vistoria => r1.nm_logra_loc_sinis
						, p_id_necessidade_vistoria => v_id_necessidade_vistoria
						, p_id_unidade_federacao_vistor => r1.sg_unidd_fedrc_loc_sinis
						, p_nm_bairro_vistoria => r1.nm_bairro_loc_sinis
						, p_nm_contato_vistoria => r1.nm_contt
						, p_nm_municipio_vistoria => r1.nm_cidad_loc_sinis
						, p_nr_ddd_contato => r1.nr_ddd_comrl_contt
						, p_nr_endereco_vistoria => r1.nr_logra_loc_sinis
						, p_nr_telefone_contato => r1.nr_telef_comrl_contt
						, p_id_sistema_origem => v_id_sistema_origem
						, p_cd_endosso => v_cd_endosso
						, p_cd_item_apolice => v_cd_item_apolice
						, p_id_produto => r1.cd_prdut
						, p_dt_historico_arquivo => r1.dt_arquv
						, p_cd_natureza_sinistro => r1.id_tipo_ocorr_sinis
						, p_cd_sequencia => r1.cd_sequencia_cobertura
						, p_id_item_tmsr => v_id_item_tmsr
						, p_cd_cobertura_basica => r1.cd_cobertura_basica
						, p_cd_cobertura_adicional => r1.cd_cobertura_adicional
						, p_cd_cobertura_especial => r1.cd_cobertura_especial
						, p_cd_cober_espec_espec => r1.cd_cobertura_espec_especial
						, p_cd_tipo_vistoria_sinistro => r1.cd_tipo_vistoria_sinistro
						, p_mens => p_mens
					);
				exception
					when others then
						p_mens := 'Falha ao executar sini7070_006.pre_update. Erro: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				if p_mens is not null then
					raise v_saida_anormal;
				end if;
				--
			end if;
			--
			v_lixo_varchar := null;
			v_lixo_date    := null;
			--recupera cod. da cidade
			if r1.nm_cidad_loc_sinis is null or
			   r1.sg_unidd_fedrc_loc_sinis is null then
				p_mens := 'Cidade ou UF da vistoria/acidente não informado.';
				raise v_saida_anormal;
			end if;
			--
			begin
				select lc.cd_cidade
				  into v_cd_cidade_vistoria
				  from logradouro_cidade lc
				 where upper(lc.nm_cidade) =
				       upper(r1.nm_cidad_loc_sinis)
				   and upper(lc.id_uf) =
				       upper(r1.sg_unidd_fedrc_loc_sinis)
				   and rownum = 1; --esta linha teve que ficar assim pra nao dar pau na web... sei que  ridculo, mas falaram que nao podia parar.
			exception
				when no_data_found then
					if	r1.id_tipo_recepcao	=	16	then
						null;
					else
						p_mens := 'Cidade do local da vistoria não válida.';
						raise v_saida_anormal;
					end	if;
				when others then
					p_mens := 'Problemas ao validar cidade. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;

			begin
				sini7070_006.do_key_commit_01(r1.cd_cia_sgdra,
							      --p_cd_cia_seguradora            in    out    number
							      r1.cd_cia_sgdra,
							      --p_cd_cia_seguradora_aux        in    out    number
							      v_id_sistema_origem,
							      --p_id_sistema_origem            in    out    number
							      v_cd_vistoriador_sinistro,
							      --p_cd_vistoriador_sinistro        in    out    number
							      v_cd_apolice,
							      --p_cd_apolice                in        number
							      v_id_apolice_tmsr,
							      --p_id_apolice_tmsr            in    out    number
							      v_cd_corretor,
							      --p_cd_corretor            in    out    number
							      v_id_achou_apolice,
							      --p_id_achou_apolice            in    out    varchar2
							      v_id_existe_email_corretor,
							      --p_id_existe_email_corretor        in    out    varchar2
							      'N',
							      --p_id_rollout                in        varchar2
							      1,
							      --p_id_situacao            in        number
							      v_cd_local,
							      --p_cd_local                in        number
							      r1.cd_ramo_cobertura,
							      --p_cd_ramo                in    out    number
							      r1.cd_tipo_bem_segrdo,
							      --p_cd_tipo_bem_segurado        in        number
							      r1.cd_carac_bem_segrdo,
							      --p_cd_caracteristica_bem_segur    in        number
							      v_cd_ramo_apolice,
							      --p_cd_ramo_apolice            in        number
							      v_cd_item_apolice,
							      --p_cd_item_apolice            in    out    number
							      v_cd_produto_historico,
							      --p_cd_produto_historico        in    out    number
							      v_cd_produto_arquivo,
							      --p_cd_produto_arquivo            in    out    number
							      v_cd_produto,
							      --p_cd_produto                in    out    number
							      v_cd_cobertura,
							      --p_cd_cobertura            in        number
							      v_id_ramo_produto_tmsr,
							      --p_id_ramo_produto_tmsr        in    out    number
							      v_id_tipo_endosso_tmsr,
							      --p_id_tipo_endosso_tmsr        in    out    number
							      v_id_endosso_tmsr,
							      --p_id_endosso_tmsr            in    out    number
							      v_id_item_tmsr,
							      --p_id_item_tmsr            in    out    number
							      v_cd_produto_tmsr,
							      --p_cd_produto_tmsr            in    out    number
							      r1.id_tipo_ocorr_sinis,
							      --p_cd_natureza_sinistro        in        number
							      r1.dt_ocorrencia,
							      --p_dt_ocorrencia            in        date
							      1,
							      --p_id_tipo_processo            in        number
							      2,
							      --p_id_tipo_informante            in        number
							      r1.nm_comnt,
							      --p_nm_informante_reclamacao        in        varchar2
							      v_ddd_contato_comunicante,
							      --p_nr_ddd_informante            in        number
							      v_tel_contato_comunicante,
							      --p_nr_telefone_informante        in        number
							      r1.cd_sgrdo,
							      --p_cd_segurado_tela            in    out    number
							      v_cd_cidade_vistoria,
							      --p_cd_cidade_vistoria            in        number
							      r1.ds_descr_sinis,
							      --p_ds_ocorrencia            in        varchar2
							      nvl(r1.dt_aviso, sysdate),
							      --p_dt_aviso                in        date
							      'N',
							      --p_id_usuario_assistencia        in        varchar2
							      v_vl_estimativa_prejuizo,
							      --p_vl_estimativa_prejuizo        in    out    number
							      11,
							      --p_id_tipo_recepcao            in        number
							      v_id_necessidade_vistoria,
							      --p_id_necessidade_vistoria        in        varchar2
							      null,
							      --p_ds_motivo_recusa            in        varchar2
							      v_cd_analista_sinistro,
							      --p_cd_analista_sinistro        in    out    number
							      r1.nm_contt,
							      --p_nm_contato_vistoria        in        varchar2
							      v_ddd_contato_contato,
							      --p_nr_ddd_contato            in        number
							      v_tel_contato_contato,
							      --p_nr_telefone_contato        in        number
							      r1.nr_logra_loc_sinis,
							      --p_nr_endereco_vistoria        in        number
							      null,
							      --p_nr_sinistro_anterior_rollout    in        varchar2
							      'KEY-COMMIT',
							      --p_origem_chamada             in        varchar2
							      case when v_insere then 'NEW' else 'QUERY' end,
							      --p_form_status            in        varchar2
							      case when v_insere then 'NEW' else 'QUERY' end,
							      --p_block_status            in        varchar2
							      v_id_origem,
							      --p_id_origem                in        varchar2
							      v_cd_endosso,
							      --p_cd_endosso                in    out    number
							      r1.cd_prdut,
							      --p_id_produto                in    out    number
							      v_ds_produto,
							      --p_ds_produto                in    out    varchar2
							      r1.dt_arquv,
							      --p_dt_historico_arquivo        in    out    date
							      r1.dt_inico_vigen,
							      --p_dt_inicio_vigencia            in    out    date
							      r1.dt_termn_vigen,
							      --p_dt_termino_vigencia        in    out    date
							      v_nm_segurado,
							      --p_nm_segurado_tela            in    out    varchar2
							      v_cd_endereco_segurado_tela,
							      --p_cd_endereco_segurado_tela        in    out    number
							      v_ds_endereco_segurado_tela,
							      --p_ds_endereco_segurado_tela        in    out    varchar2
							      v_nr_endereco_segurado_tela,
							      --p_nr_endereco_segurado_tela        in    out    varchar2
							      v_nm_complemento_segur_tela,
							      --p_nm_complemento_segur_tela        in    out    varchar2
							      v_id_cep_segurado_tela,
							      --p_id_cep_segurado_tela        in    out    number
							      v_nm_bairro_segurado_tela,
							      --p_nm_bairro_segurado_tela        in    out    varchar2
							      v_nm_municipio_segurado_tela,
							      --p_nm_municipio_segurado_tela        in    out    varchar2
							      v_id_unida_feder_segur_tela,
							      --p_id_unida_feder_segur_tela        in    out    varchar2
							      v_ds_unida_feder_segur_tela,
							      --p_ds_unida_feder_segur_tela        in    out    varchar2
							      r1.nr_ddd_telef_resdl_sgrdo,
							      --p_nr_ddd_segurado_tela        in    out    number
							      r1.nr_telef_resdl_sgrdo,
							      --p_nr_telefone_segurado_tela        in    out    number
							      v_lixo_varchar,
							      --p_ds_mensagem_corretor        in    out    varchar2
							      r1.cd_cobertura_basica,
							      --p_cd_cobertura_basica        in    out    number
							      r1.cd_cobertura_adicional,
							      --p_cd_cobertura_adicional        in    out    number
							      r1.cd_cobertura_especial,
							      --p_cd_cobertura_especial        in    out    number
							      r1.cd_cobertura_espec_especial,
							      --p_cd_cober_espec_espec        in    out    number
							      r1.cd_sequencia_cobertura,
							      --p_cd_sequencia            in        number
							      v_id_tipo_operacao,
							      --p_id_tipo_operacao            in        number
							      v_ds_endereco_segurado_tela,
							      --p_ds_endereco_segurado        in    out    varchar2
							      v_id_cep_segurado_tela,
							      --p_id_cep_segurado            in    out    number
							      v_id_unida_feder_segur_tela,
							      --p_id_unidade_federacao_segur        in    out    varchar2
							      v_nm_bairro_segurado_tela,
							      --p_nm_bairro_segurado            in    out    varchar2
							      v_nm_complemento_segur_tela,
							      --p_nm_complemento_ender_segur        in    out    varchar2
							      v_nm_municipio_segurado_tela,
							      --p_nm_municipio_segurado        in    out    varchar2
							      v_nm_segurado,
							      --p_nm_segurado            in    out    varchar2
							      r1.nr_ddd_telef_resdl_sgrdo,
							      --p_nr_ddd_segurado            in    out    number
							      v_nr_endereco_segurado_tela,
							      --p_nr_endereco_segurado        in    out    varchar2
							      r1.nr_telef_resdl_sgrdo,
							      --p_nr_telefone_segurado        in    out    number
							      r1.nm_logra_loc_sinis,
							      --p_ds_endereco_vistoria        in    out    varchar2
							      r1.sg_unidd_fedrc_loc_sinis,
							      --p_id_unidade_federacao_vistor    in    out    varchar2
							      r1.nm_bairro_loc_sinis,
							      --p_nm_bairro_vistoria            in    out    varchar2
							      r1.nm_cidad_loc_sinis,
							      --p_nm_municipio_vistoria        in    out    varchar2
							      r1.id_cep_local_sinis,
							      --p_id_cep_local_vistoria        in        number
							      sysdate,
							      --p_dt_inclusao            in        date
							      v_cd_funcionario,
							      --p_cd_funcionario            in    out    number
							      v_lixo_varchar,
							      --p_nm_analista_sinistro        in    out    varchar2
							      v_lixo_varchar,
							      --p_nr_ddd_analista            in    out    number
							      v_lixo_varchar,
							      --p_nr_telefone_analista        in    out    number
							      v_lixo_varchar,
							      --p_id_email_analista            in    out    varchar2
							      v_vl_importancia_segurada,
							      --p_vl_importancia_segurada        in    out    number
							      v_lixo_varchar,
							      --p_voltar_campo                out    varchar2
							      null,
							      null,
							      p_mens
							      --p_mens                    out    varchar2
							      );
			exception
				when others then
					p_mens := 'Problemas na chamada da rotina SINI7070_006.DO_KEY_COMMIT_01. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			if p_mens is not null then
				raise v_saida_anormal;
			end if;
			-- Eduardo Augusto - Regra para Afinidades RE
			-- No caso de Afinidades,  necessrio resgatar a variavel v_id_alerta_vl_min_abert_os, que antes era calculada somente
			-- no Forms. Esse valor define o template de e-mail automatizado a ser enviado para o cliente nos casos com aplice.
			if v_id_achou_apolice = 'S' and
			   r1.cd_tipo_bem_segrdo = 4 and
			   r1.cd_carac_bem_segrdo = 1 and
			   r1.cd_ramo_cobertura = 71 then
				-- Busca os valores da IS Original, Estimativa Utilizada e Estimativa Calculada
				begin
					gp_controle_is_0001.prc_retorna_vl_is_estimativas(null,
											  r1.cd_tipo_bem_segrdo,
											  r1.cd_carac_bem_segrdo,
											  nvl(v_cd_produto_tmsr,
											      0),
											  r1.cd_cia_sgdra,
											  v_id_ramo_produto_tmsr,
											  v_id_apolice_tmsr,
											  v_id_item_tmsr,
											  v_id_endosso_tmsr,
											  v_id_tipo_endosso_tmsr,
											  r1.cd_cobertura_basica,
											  r1.cd_cobertura_adicional,
											  r1.cd_ramo_cobertura,
											  r1.id_tipo_ocorr_sinis,
											  null,
											  v_vl_valor_is_original,
											  v_vl_estimativa_utilizada,
											  v_vl_est_calculada,
											  v_vl_is_atual,
											  v_id_aplica_perc_is_prim_sin,
											  v_is_primeiro_reparo,
											  p_mens);
				exception
					when others then
						p_mens := 'SINI7070_008.prc_finaliza_aviso_re - Erro ao Executar gp_controle_is_0001.prc_retorna_vl_is_estimativas - ERRO: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				end;
				if p_mens is not null then
					raise v_saida_anormal;
				end if;
				begin
					sini7070_006.prc_ret_vl_minimo_abert_os(r1.cd_tipo_bem_segrdo,
										r1.cd_carac_bem_segrdo,
										r1.cd_ramo_cobertura,
										r1.id_tipo_ocorr_sinis,
										v_vl_valor_minimo_abertura_os,
										v_lixo_varchar,
										p_mens);
				exception
					when others then
						p_mens := 'Problemas na chamada da rotina SINI7070_006.PRC_RET_VL_MINIMO_ABERT_OS. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				end;
				if nvl(v_vl_valor_minimo_abertura_os, 0) > 0 then
					if nvl(v_vl_estimativa_utilizada, 0) = 0 then
						if nvl(v_vl_is_atual, 0) <
						   nvl(v_vl_valor_minimo_abertura_os,
						       0) then
							v_id_alerta_vl_min_abert_os := 'S';
						end if;
					else
						if nvl(v_vl_est_calculada,
						       0) < nvl(v_vl_valor_minimo_abertura_os,
								0) then
							v_id_alerta_vl_min_abert_os := 'S';
						end if;
					end if;
				end if;
			end if;
			--

			if v_insere then
				begin
					insert into sinistro_reclamacao_eleme
						(cd_reclamacao_elementar, --number(20) not null,
						 dt_ocorrencia, --date,
						 dt_aviso, --date,
						 id_tipo_recepcao, --number(2) not null,
						 nm_informante_reclamacao, --varchar2(80),
						 nr_ddd_informante, --number(4),
						 nr_telefone_informante, --number(8),
						 nr_ddd_celular_informante, --number(4),
						 nr_celular_informante, --number(10),
						 id_email_informante, --varchar2(50),
						 nm_segurado, --varchar2(100),
						 ds_endereco_segurado, --varchar2(70),
						 nr_endereco_segurado, --number(6),
						 nm_complemento_ender_segur, --varchar2(50),
						 id_cep_segurado, --number(8),
						 nm_bairro_segurado, --varchar2(60),
						 nm_municipio_segurado, --varchar2(50),
						 id_unidade_federacao_segur, --varchar2(2),
						 nr_ddd_segurado, --number(4),
						 nr_telefone_segurado, --number(8),
						 id_cep_local_vistoria, --number(8),
						 ds_endereco_vistoria, --varchar2(70),
						 nr_endereco_vistoria, --
						 nm_complemento_ender_vistor,
						 cd_cidade_vistoria, --number(6),
						 nm_bairro_vistoria, --VARCHAR2(60),
						 nm_municipio_vistoria, --VARCHAR2(50),
						 id_unidade_federacao_vistor, --varchar2(2)
						 nm_contato_vistoria, --varchar2(80),
						 nr_ddd_contato, --number(4),
						 nr_telefone_contato, --number(8),
						 ds_natureza_sinistro, --varchar2(80),
						 ds_ocorrencia, --varchar2(4000),
						 vl_estimativa_prejuizo, --number(15,2),
						 ds_observacao, --varchar2(200),
						 cd_funcionario, --number(6) not null,
						 cd_analista_sinistro, --number(6) not null,
						 cd_vistoriador_sinistro, --number(3),
						 dt_inclusao, --date not null,
						 nm_usuario_inclusao, --varchar2(20) not null,
						 id_situacao, --number(2) not null,
						 id_tipo_informante, --number(2) not null,
						 id_necessidade_vistoria, --varchar2(1) not null,
						 cd_tipo_bem_segurado, --number(2),
						 cd_caracteristica_bem_segur, --number(2),
						 cd_ramo, --number(4),
						 cd_endosso, --number(7),
						 id_origem, --varchar2(1),
						 cd_local, --number(3),
						 cd_ramo_apolice, --number(4),
						 cd_apolice, --number(6),
						 cd_item_apolice, --number(7),
						 cd_produto, --number(4),
						 cd_produto_historico, --number(4),
						 cd_produto_arquivo, --number(4),
						 dt_historico_arquivo, --date,
						 cd_natureza_sinistro, --number(3),
						 cd_cobertura_basica, --number(6),
						 cd_cobertura_adicional, --number(6),
						 cd_cobertura_especial, --number(4),
						 cd_sequencia, --number(5),
						 cd_cober_espec_espec, --number(4),
						 vl_estimativa_preju_original, --number(15,2),
						 id_chassi, --varchar2(100),
						 nr_ddd_contato_segurado, --number(4),
						 nr_telefone_contato_segurado, --number(8),
						 cd_cia_seguradora, --number(5),
						 id_sistema_origem, --number(2),
						 id_ramo_produto_tmsr, --number(3),
						 id_apolice_tmsr, --number(8),
						 id_item_tmsr, --number(7),
						 id_tipo_endosso_tmsr, --number(1),
						 id_endosso_tmsr, --number(8),
						 cd_produto_tmsr, --number(6),
						 id_rollout, --varchar2(1) not null,
						 id_tipo_processo, --number(1),
						 id_receber_sms, --varchar2(1),
						 cd_tipo_bem_danificado, --varchar2(1),
						 id_terceiro,
						 ds_bens,
						 id_forma_contato, --number(3)       ,
						 nr_ddd_cel_contato, --number(4)       ,
						 nr_tel_cel_contato, --number(10)      ,
						 id_email_contato, --varchar2(50)    ,
						 nr_bo, --varchar2(15)    ,
						 nr_delegacia, --number(6),
						 vl_estimativa_web, --number(15,2)    ,
						 id_ctrc, --number(25)
						 id_usuario_assistencia, --TOP_SERVICE
						 id_afinidade_manual, --
						 nr_ddd_sms, --number(4),
						 nr_celular_sms, --number(12),
						 id_autoriza_envio_email,
						 nm_empresa_transportadora,
						 id_nota_fiscal,
						 id_matricula, --VARCHAR2(30) --Endesa
						 cd_linha, --afinidades
						 cd_tipo_operacao_afinidades, --afinidades
						 cd_classificacao_equipamento, --afinidades
						 cd_marca_equipamento, --afinidades
						 cd_categoria_equipamento, --afinidades
						 cd_modelo_equipamento, --afinidades
						 nm_segurado_individual, --VARCHAR2(80) afinidades
						 nr_cgc_cpf_segurado,
						 nr_estabelecimento_segurado,
						 nr_digito_verificador,
						 id_alerta_vl_min_abert_os,
						 ds_marca,
						 id_comunicante_sabe_valor,
						 cd_benefsinis_assistencia,
						 nm_outro_prest_assistencia,
						 id_email_prest_assistencia,
						 vl_qtde_itens_sinist,
						 id_necessidade_perito,
						 cd_perito_sinistro,
						 id_email_segurado,
						 qt_moeda_prejuizo,
						 id_causa,
             					id_possui_veiculo,
						nm_contato_vistoria_agro,
						nr_ddd_contato_vistoria,
						nr_tel_contato_vistoria
						, id_canal_origem)  -- SinistroDigitalResidencial
					values
						(v_cd_reclamacao_elementar, --number(20) not null,
						 r1.dt_ocorrencia, --date,
						 nvl(r1.dt_aviso, trunc(sysdate)), --date,
						 nvl(r1.id_tipo_recepcao,9), --id_tipo_recepcao              number(2) not null,
						 r1.nm_comnt, --nm_informante_reclamacao      varchar2(80),
						 r1.nr_ddd_telef_comrl_comnt, --number(4),
						 r1.nr_telef_comrl_comnt, --number(13),
						 r1.nr_ddd_celul_comnt, --nr_ddd_informante             number(4),
						 r1.nr_telef_celul_comnt, --nr_telefone_informante        number(8),
						 r1.cd_email_comnt, --varchar2(50),
						 r1.nm_sgrdo, --nm_segurado                   varchar2(100),
						 nvl(v_ds_endereco_segurado_tela,r1.nm_logra_loc_risco), --ds_endereco_segurado          varchar2(70),
						 nvl(v_nr_endereco_segurado_tela,r1.nr_logra_loc_risco), --nr_endereco_segurado          number(6),
						 nvl(v_nm_complemento_segur_tela,r1.ds_cmplo_loc_risco), --nm_complemento_ender_segur    varchar2(50),
						 nvl(v_id_cep_segurado_tela,r1.id_cep_segurado), --id_cep_segurado               number(8),
						 nvl(v_nm_bairro_segurado_tela, 'Não se Aplica'), --nm_bairro_segurado            varchar2(60),
						 nvl(v_nm_municipio_segurado_tela,r1.nm_cidad_loc_risco), --nm_municipio_segurado         varchar2(50),
						 nvl(v_id_unida_feder_segur_tela,r1.sg_unidd_fedrc_loc_risco), --id_unidade_federacao_segur    varchar2(2),
						 r1.nr_ddd_celul_sgrdo, --nr_ddd_segurado               number(4),
						 r1.nr_telef_celul_sgrdo, --nr_telefone_segurado          number(8),
						 r1.id_cep_local_sinis, --id_cep_local_vistoria         number(8),
						 r1.nm_logra_loc_sinis, --ds_endereco_vistoria          varchar2(70),
						 r1.nr_logra_loc_sinis, --nr endereco ocorrencia
						 r1.ds_complemento_loc_sinis,
						 v_cd_cidade_vistoria, --cd_cidade_vistoria            number(6),
						 r1.nm_bairro_loc_sinis, --nm_bairro_vistoria
						 r1.nm_cidad_loc_sinis, --nm_municipio_vistoria
						 r1.sg_unidd_fedrc_loc_sinis, --UF_vistoria
						 r1.nm_contt, --nm_contato_vistoria           varchar2(80),
						 r1.nr_ddd_comrl_contt, --nr_ddd_contato                number(4),
						 r1.nr_telef_comrl_contt, --nr_telefone_contato           number(8),
						 v_ds_natureza, --ds_natureza_sinistro          varchar2(80),
						 r1.ds_descr_sinis, --ds_ocorrencia                 varchar2(4000),
						 v_vl_estimativa_prejuizo, --vl_estimativa_prejuizo        number(15,2),
						 r1.cd_observ_sinis, --ds_observacao                 varchar2(200),
						 v_cd_funcionario, --cd_funcionario                number(6) not null,
						 v_cd_analista_sinistro, --cd_analista_sinistro          number(6) not null,
						 v_cd_vistoriador_sinistro, --cd_vistoriador_sinistro       number(3),
						 sysdate, --dt_inclusao                   date not null,
						 substr(nvl(r1.nm_usuro_alter,
							    r1.nm_usuro_incls),
							1,
							20), --nm_usuario_inclusao             ,,--nm_usuario_inclusao           varchar2(20) not null,
						 v_id_situacao, --id_situacao                   number(2) not null,
						 nvl(r1.id_tipo_informante, 2), --id_tipo_informante            number(2) not null,--corretor
						 v_id_necessidade_vistoria, --id_necessidade_vistoria       varchar2(1) not null,
						 r1.cd_tipo_bem_segrdo, --cd_tipo_bem_segurado          number(2),
						 r1.cd_carac_bem_segrdo, --cd_caracteristica_bem_segur   number(2),
						 r1.cd_ramo_cobertura, --cd_ramo                       number(4),
						 v_cd_endosso, --cd_endosso                    number(7),
						 v_id_origem, --id_origem                     varchar2(1),
						 v_cd_local, --cd_local                      number(3),
						 v_cd_ramo_apolice, --cd_ramo_apolice               number(4),
						 v_cd_apolice, --cd_apolice                    number(6),
						 v_cd_item_apolice, --cd_item_apolice               number(7),
						 v_cd_produto, --cd_produto                    number(4),
						 v_cd_produto_historico, --cd_produto_historico          number(4),
						 v_cd_produto_arquivo, --cd_produto_arquivo            number(4),
						 r1.dt_arquv, --dt_historico_arquivo          date,
						 r1.id_tipo_ocorr_sinis, --cd_natureza_sinistro          number(3),
						 r1.cd_cobertura_basica, --cd_cobertura_basica           number(6),
						 r1.cd_cobertura_adicional, --cd_cobertura_adicional        number(6),
						 r1.cd_cobertura_especial, --cd_cobertura_especial         number(4),
						 r1.cd_sequencia_cobertura, --cd_sequencia                  number(5),
						 r1.cd_cobertura_espec_especial, --cd_cober_espec_espec          number(4),
						 null, --vl_estimativa_preju_original  number(15,2),
						 r1.cd_chassi, --id_chassi                     varchar2(100),
						 r1.nr_ddd_telef_comrl_sgrdo, --nr_ddd_contato_segurado       number(4),
						 r1.nr_telef_comrl_sgrdo, --nr_telefone_contato_segurado  number(8),
						 r1.cd_cia_sgdra, --cd_cia_seguradora             number(5),
						 v_id_sistema_origem, --id_sistema_origem             number(2),
						 v_id_ramo_produto_tmsr, --id_ramo_produto_tmsr          number(3),
						 v_id_apolice_tmsr, --id_apolice_tmsr               number(8),
						 v_id_item_tmsr, --id_item_tmsr                  number(7),
						 v_id_tipo_endosso_tmsr, --id_tipo_endosso_tmsr          number(1),
						 v_id_endosso_tmsr, --id_endosso_tmsr               number(8),
						 v_cd_produto_tmsr, --cd_produto_tmsr               number(6),
						 'N', --id_rollout                    varchar2(1) not null,
						 1, --id_tipo_processo              number(1),
						 r1.cd_envia_sms_contt, --id_receber_sms                varchar2(1),
						 'O', --cd_tipo_bem_danificado        varchar2(1),
						 'N',
						 r1.cd_bens_dani_sinis, --ds_bens             varchar2(200)
						 r1.cd_forma_contt, --id_forma_contato                ,--number(3)       ,
						 r1.nr_ddd_celul_contt, --nr_ddd_cel_contato              ,--number(4)       ,                                                                                         nr_tel_cel_contato              ,--number(10)      ,
						 r1.nr_telef_celul_contt, --nr_tel_cel_contato              ,--number(4)       ,
						 r1.cd_email_contt, --id_email_contato                ,--varchar2(50)    ,
						 r1.cd_num_bo, --nr_bo                           ,--varchar2(15)    ,
						 r1.id_deleg_bo, --number(6),
						 nvl(r1.vl_prej_informado,r1.vl_estimativa_prejuizo), --nvl SinistroDigitalResidencial--vl_estimativa_web               ,--number(15,2)    ,
						 r1.cd_ctrc, --id_ctrc                         --number(25)
						 'N', --top_service
						 'N', --afinidade
						 nvl(r1.nr_ddd_celul_sgrdo,r1.nr_ddd_celul_contt), --number(4),
						 nvl(r1.nr_telef_celul_sgrdo,r1.nr_telef_celul_contt), --number(13),
						 nvl(r1.cd_autoriza_envio_email,
						     'N'),
						 r1.nm_transportadora,
						 r1.cd_nota_fiscal,
						 r1.id_matricula, -- EndesA
						 r1.cd_linha, --afinidades
						 r1.cd_tipo_operacao_afinidades, --afinidades
						 r1.cd_classificacao_equipamento, --afinidades
						 r1.cd_marca_equipamento, --afinidades
						 r1.cd_categoria_equipamento, --afinidades
						 r1.cd_modelo_equipamento, --afinidades
						 v_nm_segurado_individual, --nm_segurado_individual     --afinidades
						 v_nr_cgc_cpf_segurado, --nr_cgc_cpf_segurado
						 v_nr_estabelecimento_segurado, --nr_estabelecimento_segurado
						 v_digito_verificador, --nr_digito_verificador
						 v_id_alerta_vl_min_abert_os,
						 r1.ds_marca,
						 v_id_comun_sabe_valor,
						 r1.cd_benefsinis_assistencia,
						 r1.nm_outro_prest_assistencia,
						 r1.cd_email_prest_assistencia,
						 r1.vl_qtde_itens_sinist,
						 r1.id_necessidade_perito,
						 r1.cd_perito_sinistro,
						 r1.cd_email_sgrdo,
						 r1.qt_moeda_prejuizo,
						 r1.id_causa,
             					r1.id_possui_veiculo,
						r1.nm_contato_vistoria,
						r1.nr_ddd_contato_vistoria,
						r1.nr_tel_contato_vistoria
						, r1.id_canal_origem);  -- SinistroDigitalResidencial

				exception
					when others then
						p_mens := 'Problemas ao tentar inserir dados na tabela SINISTRO_RECLAMACAO_ELEME. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;



          ------------  OS-40960

          begin

            begin

              select f.nm_funcionario,
                     gpo.cd_grupo_processo,
                     gpo.ds_grupo_processo
                into v_nm_analista_sinistro,
                     v_cd_grupo_analista,
                     v_ds_grupo_analista
                from sinistro_analista       an,
                     funcionario             f,
                     sinistro_grupo_processo gpo
               where an.cd_funcionario = f.cd_funcionario
                 and an.cd_grupo_processo = gpo.cd_grupo_processo
                 and an.cd_analista_sinistro = v_cd_analista_sinistro;

            exception

              when others then

                p_ds_fase := 'Não foi possível recuperar o analista responsável pelo processo (cod. 7070_008). Erro: ' ||
                             sqlerrm;

            end;

            begin

              if p_ds_fase is null then

                p_ds_fase := 'Aviso de sinistro distribuído automaticamente para o analista ' || v_cd_analista_sinistro || ' - ' || v_nm_analista_sinistro || ' (Grupo: ' ||v_cd_grupo_analista || '/' || v_ds_grupo_analista || ' - ' ||
                             ' Estimativa :  ' || v_vl_estimativa_prejuizo || ' - ' ||
                             ' Local :  ' || v_cd_local || ' - ' ||
                             ' Ramo :  ' || r1.cd_ramo_cobertura || ' - ' ||
                             ' Produto :  ' || v_cd_produto || ' - ' ||
                             ' Produto TMSR :  ' || v_cd_produto_tmsr ||' - ' ||
                             ' Sistema Origem :  ' ||v_id_sistema_origem || ' - ' ||
                              'Apólice: ' || v_id_apolice_tmsr || ' ).';

              end if;
              sini2086_002(p_ds_fase                     => p_ds_fase,
                           p_aviso                       => v_cd_reclamacao_elementar,
                           p_id_origem                   => 2,
                           p_cd_letra_sinistro           => null,
                           p_cd_local_contabil           => null,
                           p_cd_tipo_bem_segurado        => null,
                           p_cd_caracteristica_bem_segur => null,
                           p_cd_ramo                     => null,
                           p_cd_sinistro                 => null,
                           p_cd_reclamante_sinistro      => null,
                           p_msgerro                     => p_mens,
                           p_id_consulta_fase_liberada   => 'N',
                           p_id_controle_relatorio       => null,
                           p_cd_fase_padrao              => null,
                           p_cd_funcionario              => null,
                           p_ultimo_documento            => null,
                           p_workflow                    => null,
                           p_id_parametro                => null,
                           p_id_chassi                   => null);

            exception
              when others then
                --- abertura no ser interrompida
                null;

            end;

          exception
            when others then

              null;

          end;

          if p_mens is not null then

             p_mens := null;

          end if;
          --
          ------------

			else
				--
				--	PREPARA PARA GERAR HISTÓRICO DA ALTERAÇÃO DE CAUSA E NATUREZA
				--
				begin
					select	sincausa.descricao
					into	v_causa_anterior
					from	sinistro_reclamacao_eleme sre,
						sinistro_causa sincausa
					where	sre.cd_reclamacao_elementar = v_cd_reclamacao_elementar
					and	sre.id_causa = sincausa.cd_causa;
				exception
					when no_data_found	then
						v_causa_anterior := null;
					when others then
						p_mens:= 'Falha ao buscar causa anterior. Não será possível salvar - ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				--
				begin
					select	sincausa.descricao
					into	v_causa_atual
					from	sinistro_causa sincausa
					where	sincausa.cd_causa = r1.id_causa;
				exception
					when no_data_found then
						v_causa_atual := null;
					when others then
						p_mens:= 'Falha ao buscar nova causa. Não será possível salvar - ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				--
				-- VERIFICA SE O SINISTRO FOI GERADO
				v_sinistro_gerado := true;
				begin
					select	s.cd_letra_sinistro,
						s.cd_local_contabil,
						s.cd_tipo_bem_segurado,
						s.cd_caracteristica_bem_segur,
						s.cd_ramo,
						s.cd_sinistro
					into
						v_cd_letra_sinistro,
						v_cd_local_contabil,
						v_cd_tipo_bem_segurado,
						v_cd_caracteristica_bem_segur,
						v_cd_ramo,
						v_cd_sinistro
					from
						sinistro	s
					where
						s.cd_reclamacao_elementar = v_cd_reclamacao_elementar;
				exception
					when	no_data_found	then
						v_sinistro_gerado := false;
					when	others	then
						p_mens:= 'Falha ao buscar sinistro. Não será possível salvar - ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				--
				-- SE O SINISTRO FOI GERADO, A NATUREZA SERÁ ATUALIZADA NA TABELA SINISTRO TAMBÉM E SERÁ GERADO UM LOG.
				if	v_sinistro_gerado	then
					--
					-- PREPARANDO LOG DA ALTERAÇÃO DE NATUREZA
					begin
						select	sn.ds_natureza_sinistro
						into	v_ds_natureza_atual
						from	sinistro_natureza	sn
						where	sn.cd_natureza_sinistro	=	r1.id_tipo_ocorr_sinis;
					exception
						when no_data_found then
							v_ds_natureza_atual := null;
						when others then
							p_mens:= 'Falha ao buscar nova natureza. Não será possível salvar - ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
					--
					begin
						select	sn.ds_natureza_sinistro
						into	v_ds_natureza_anterior
						from	sinistro_natureza	sn,
							sinistro_reclamacao_eleme	sre
						where	sn.cd_natureza_sinistro		=	sre.cd_natureza_sinistro
						and	sre.cd_reclamacao_elementar	=	v_cd_reclamacao_elementar;
					exception
						when no_data_found then
							v_ds_natureza_anterior := null;
						when others then
							p_mens:= 'Falha ao buscar natureza anterior. Não será possível salvar - ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
				end if;

				--
				begin
					if v_sinistro_gerado then
						v_gerado_sinistro := 'S';
					else
						v_gerado_sinistro := 'N';
					end if;

					update sinistro_reclamacao_eleme
					set
						dt_ocorrencia=r1.dt_ocorrencia,
						dt_aviso=nvl(r1.dt_aviso, trunc(sysdate)),
						nm_informante_reclamacao=r1.nm_comnt,
						nr_ddd_informante=r1.nr_ddd_telef_comrl_comnt,
						nr_telefone_informante  =r1.nr_telef_comrl_comnt,
						nr_ddd_celular_informante=r1.nr_ddd_celul_comnt,
						nr_celular_informante=r1.nr_telef_celul_comnt,
						id_email_informante =r1.cd_email_comnt,
						nm_segurado =r1.nm_sgrdo,
						ds_endereco_segurado=nvl(v_ds_endereco_segurado_tela,r1.nm_logra_loc_risco),
						nr_endereco_segurado=nvl(v_nr_endereco_segurado_tela,r1.nr_logra_loc_risco),
						nm_complemento_ender_segur=nvl(v_nm_complemento_segur_tela,r1.ds_cmplo_loc_risco),
						id_cep_segurado=nvl(v_id_cep_segurado_tela,r1.id_cep_segurado),
						nm_bairro_segurado=nvl(v_nm_bairro_segurado_tela, 'Não se Aplica'),
						nm_municipio_segurado=nvl(v_nm_municipio_segurado_tela,r1.nm_cidad_loc_risco),
						id_unidade_federacao_segur=nvl(v_id_unida_feder_segur_tela,r1.sg_unidd_fedrc_loc_risco),
						nr_ddd_segurado =r1.nr_ddd_celul_sgrdo,
						nr_telefone_segurado=r1.nr_telef_celul_sgrdo,
						id_cep_local_vistoria=r1.id_cep_local_sinis,
						ds_endereco_vistoria=r1.nm_logra_loc_sinis,
						nr_endereco_vistoria=r1.nr_logra_loc_sinis,
						nm_complemento_ender_vistor =r1.ds_complemento_loc_sinis,
						cd_cidade_vistoria  =v_cd_cidade_vistoria,
						nm_bairro_vistoria  =r1.nm_bairro_loc_sinis,
						nm_municipio_vistoria= r1.nm_cidad_loc_sinis,
						id_unidade_federacao_vistor = r1.sg_unidd_fedrc_loc_sinis,
						nm_contato_vistoria =r1.nm_contt,
						nr_ddd_contato  =r1.nr_ddd_comrl_contt,
						nr_telefone_contato =r1.nr_telef_comrl_contt,
						ds_natureza_sinistro=v_ds_natureza,
						ds_ocorrencia=r1.ds_descr_sinis,
						vl_estimativa_prejuizo  =v_vl_estimativa_prejuizo,
						ds_observacao=r1.cd_observ_sinis,
						--cd_funcionario  =v_cd_funcionario,
						cd_analista_sinistro=v_cd_analista_sinistro,
						cd_vistoriador_sinistro =v_cd_vistoriador_sinistro,
						--dt_inclusao =sysdate,
						--nm_usuario_inclusao =substr(nvl(r1.nm_usuro_alter,r1.nm_usuro_incls),1,20),
						id_situacao = v_id_situacao,
						id_tipo_informante  = r1.id_tipo_informante,
						id_necessidade_vistoria =v_id_necessidade_vistoria,
						cd_tipo_bem_segurado=r1.cd_tipo_bem_segrdo,
						cd_caracteristica_bem_segur =r1.cd_carac_bem_segrdo,
						cd_ramo =r1.cd_ramo_cobertura,
						cd_endosso  =v_cd_endosso,
						id_origem=v_id_origem,
						cd_local=v_cd_local,
						cd_ramo_apolice =v_cd_ramo_apolice,
						cd_apolice  =v_cd_apolice,
						cd_item_apolice =v_cd_item_apolice,
						cd_produto  =v_cd_produto,
						cd_produto_historico=v_cd_produto_historico,
						cd_produto_arquivo  =v_cd_produto_arquivo,
						dt_historico_arquivo=r1.dt_arquv,
						cd_natureza_aprovar	= case when v_gerado_sinistro = 'S' then r1.id_tipo_ocorr_sinis else null end,
						cd_natureza_sinistro	= case when v_gerado_sinistro = 'S' then cd_natureza_sinistro else r1.id_tipo_ocorr_sinis end,
						--cd_natureza_aprovar=r1.id_tipo_ocorr_sinis,
						cd_cobertura_basica =r1.cd_cobertura_basica,
						cd_cobertura_adicional  =r1.cd_cobertura_adicional,
						cd_cobertura_especial=r1.cd_cobertura_especial,
						cd_sequencia=r1.cd_sequencia_cobertura,
						cd_cober_espec_espec=r1.cd_cobertura_espec_especial,
						vl_estimativa_preju_original=null,
						id_chassi=r1.cd_chassi,
						nr_ddd_contato_segurado =r1.nr_ddd_telef_comrl_sgrdo,
						nr_telefone_contato_segurado=r1.nr_telef_comrl_sgrdo,
						cd_cia_seguradora=r1.cd_cia_sgdra,
						id_sistema_origem=v_id_sistema_origem,
						id_ramo_produto_tmsr=v_id_ramo_produto_tmsr,
						id_apolice_tmsr =v_id_apolice_tmsr,
						id_item_tmsr=v_id_item_tmsr,
						id_tipo_endosso_tmsr=v_id_tipo_endosso_tmsr,
						id_endosso_tmsr =v_id_endosso_tmsr,
						cd_produto_tmsr =v_cd_produto_tmsr,
						id_rollout  ='N',
						id_tipo_processo=1,
						id_receber_sms  =r1.cd_envia_sms_contt,
						cd_tipo_bem_danificado  ='O',
						id_terceiro ='N',
						ds_bens =r1.cd_bens_dani_sinis,
						id_forma_contato=r1.cd_forma_contt,
						nr_ddd_cel_contato  =r1.nr_ddd_celul_contt,
						nr_tel_cel_contato  =r1.nr_telef_celul_contt,
						id_email_contato=r1.cd_email_contt,
						nr_bo=r1.cd_num_bo,
						nr_delegacia=r1.id_deleg_bo,
						vl_estimativa_web=r1.vl_estimativa_prejuizo,
						id_ctrc =r1.cd_ctrc,
						id_usuario_assistencia  ='N',
						id_afinidade_manual ='N',
						nr_ddd_sms  =nvl(r1.nr_ddd_celul_sgrdo,r1.nr_ddd_celul_contt),
						nr_celular_sms  =nvl(r1.nr_telef_celul_sgrdo,r1.nr_telef_celul_contt),
						id_autoriza_envio_email =nvl(r1.cd_autoriza_envio_email,'N'),
						nm_empresa_transportadora=r1.nm_transportadora,
						id_nota_fiscal  =r1.cd_nota_fiscal,
						id_matricula=r1.id_matricula,
						cd_linha=r1.cd_linha,
						cd_tipo_operacao_afinidades =r1.cd_tipo_operacao_afinidades,
						cd_classificacao_equipamento=r1.cd_classificacao_equipamento,
						cd_marca_equipamento=r1.cd_marca_equipamento,
						cd_categoria_equipamento=r1.cd_categoria_equipamento,
						cd_modelo_equipamento=r1.cd_modelo_equipamento,
						nm_segurado_individual  =v_nm_segurado_individual,
						nr_cgc_cpf_segurado =v_nr_cgc_cpf_segurado,
						nr_estabelecimento_segurado =v_nr_estabelecimento_segurado,
						nr_digito_verificador=v_digito_verificador,
						id_alerta_vl_min_abert_os=v_id_alerta_vl_min_abert_os,
						ds_marca=r1.ds_marca,
						id_comunicante_sabe_valor=v_id_comun_sabe_valor,
						cd_benefsinis_assistencia=r1.cd_benefsinis_assistencia,
						nm_outro_prest_assistencia  =r1.nm_outro_prest_assistencia,
						id_email_prest_assistencia  =r1.cd_email_prest_assistencia,
						vl_qtde_itens_sinist=r1.vl_qtde_itens_sinist,
						id_necessidade_perito=r1.id_necessidade_perito,
						cd_perito_sinistro  = r1.cd_perito_sinistro,
						id_email_segurado = r1.cd_email_sgrdo,
						qt_moeda_prejuizo = r1.qt_moeda_prejuizo,
						id_causa = r1.id_causa,
						id_possui_veiculo = r1.id_possui_veiculo,
						dt_alteracao = trunc(sysdate),
						nm_usuario_alteracao = substr(nvl(r1.nm_usuro_alter, r1.nm_usuro_incls),1,20),
						nm_contato_vistoria_agro	=	r1.nm_contato_vistoria,
						nr_ddd_contato_vistoria		=	r1.nr_ddd_contato_vistoria,
						nr_tel_contato_vistoria		=	r1.nr_tel_contato_vistoria

					where
						cd_reclamacao_elementar = v_cd_reclamacao_elementar;
				exception
					when others then
						p_mens := 'Problemas ao tentar atualizar dados na tabela SINISTRO_RECLAMACAO_ELEME. Erro: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				--
				--	GERA HISTÓRICO ALTERAÇÃO CAUSA E NATUREZA
				--
				if v_causa_anterior <> v_causa_atual then

					-- ATUALIZA FLAG DE CAUSA ALTERADA
					if	v_sinistro_gerado	then
						begin
							update	sinistro_reclamante sr
							set	sr.id_causa_alterada		= 'S'
							where	sr.cd_letra_sinistro		= v_cd_letra_sinistro
							and	sr.cd_local_contabil		= v_cd_local_contabil
							and	sr.cd_tipo_bem_segurado 	= v_cd_tipo_bem_segurado
							and	sr.cd_caracteristica_bem_segur	= v_cd_caracteristica_bem_segur
							and	sr.cd_ramo			= v_cd_ramo
							and	sr.cd_sinistro			= v_cd_sinistro;
						exception
							when	others	then
								p_mens:= 'Falha ao atualizar FLAG de alteração de causa - ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;
						end;
					end if;

					sini2086_002(	p_ds_fase => 'CAUSA ALTERADA DE: ' || v_causa_anterior || ' PARA: ' || v_causa_atual,
									p_aviso => v_cd_reclamacao_elementar,
									p_id_origem => 2,
									p_cd_letra_sinistro => null,
									p_cd_local_contabil => null,
									p_cd_tipo_bem_segurado => null,
									p_cd_caracteristica_bem_segur => null,
									p_cd_ramo => null,
									p_cd_sinistro => null,
									p_cd_reclamante_sinistro => null,
									p_msgerro => p_mens,
									p_id_consulta_fase_liberada => 'S',
									p_id_controle_relatorio => null,
									p_cd_fase_padrao => null,
									p_cd_funcionario => REGEXP_REPLACE(nvl(r1.nm_usuro_alter, r1.nm_usuro_incls),'[^[:digit:]]'), -- Só numeros
									p_ultimo_documento => null,
									p_workflow => null,
									p_id_parametro => null,
									p_id_chassi => null);
					if p_mens is not null then
						p_mens:= 'Falha ao gravar histórico de alteração de CAUSA: ' || p_mens;
						raise v_saida_anormal;
					end if;
				end if;
				--
				-- ATUALIZA FLAG DE NATUREZA ALTERADA
				if	v_sinistro_gerado	then
					--
					if v_ds_natureza_anterior <> v_ds_natureza_atual then

						begin
							update	sinistro	s
							set	s.cd_natureza_aprovar	= r1.id_tipo_ocorr_sinis
							where	s.cd_reclamacao_elementar = v_cd_reclamacao_elementar;
						exception
							when	others	then
								p_mens:= 'Falha ao atualizar a natureza no sinistro. Não será possível salvar - ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;
						end;
						--
						begin
							update	sinistro_reclamante sr
							set	sr.id_aprova_natureza		= 'N'
							where	sr.cd_letra_sinistro		= v_cd_letra_sinistro
							and	sr.cd_local_contabil		= v_cd_local_contabil
							and	sr.cd_tipo_bem_segurado 	= v_cd_tipo_bem_segurado
							and	sr.cd_caracteristica_bem_segur	= v_cd_caracteristica_bem_segur
							and	sr.cd_ramo			= v_cd_ramo
							and	sr.cd_sinistro			= v_cd_sinistro;
						exception
							when	others	then
								p_mens:= 'Falha ao atualizar a chave de aprovação de alteração de natureza. Não será possível salvar - ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;
						end;

						sini2086_002(	p_ds_fase => 'NATUREZA ALTERADA DE: ' || v_ds_natureza_anterior || ' PARA: ' || v_ds_natureza_atual,
										p_aviso => v_cd_reclamacao_elementar,
										p_id_origem => 2,
										p_cd_letra_sinistro => null,
										p_cd_local_contabil => null,
										p_cd_tipo_bem_segurado => null,
										p_cd_caracteristica_bem_segur => null,
										p_cd_ramo => null,
										p_cd_sinistro => null,
										p_cd_reclamante_sinistro => null,
										p_msgerro => p_mens,
										p_id_consulta_fase_liberada => 'S',
										p_id_controle_relatorio => null,
										p_cd_fase_padrao => null,
										p_cd_funcionario => REGEXP_REPLACE(nvl(r1.nm_usuro_alter, r1.nm_usuro_incls),'[^[:digit:]]'), -- Só numeros
										p_ultimo_documento => null,
										p_workflow => null,
										p_id_parametro => null,
										p_id_chassi => null);
						if p_mens is not null then
							p_mens:= 'Falha ao gravar histórico de alteração de NATUREZA: ' || p_mens;
							raise v_saida_anormal;
						end if;
					end if;
					v_cd_letra_sinistro	:= null;
					v_cd_local_contabil	:= null;
					v_cd_sinistro		:= null;
				end if;
			end if;
			--
			-- busca dados dos veiculos na tabela temporaria e insere/atualiza na tabela final (segunda release proj. Alteracao Natureza)
			-- MODO INSERT
			--
			if v_insere then
				begin
					open c3 (p_id_aviso_sinst_re_sgrdo);
					loop
						fetch c3 into v_rec_asw24;
						--
						-- CHECA SE HÁ DADOS A TRANSFERIR PARA A TABELA PRINCIPAL
						--
						exit when c3%notfound;
						begin
							insert into SINISTRO_RECLAMACAO_ELEME_VEIC
								(
								cd_sequencia		,
								cd_reclamacao_elementar ,
								cd_fabricante           ,
								cd_modelo_veiculo	,
								cd_combustivel		,
								cd_veiculo              ,
								cd_ano_veiculo          ,
								id_placa                ,
								id_veiculo		,
								dt_inclusao             ,
								nm_usuario_inclusao
								)
							values
								(
								srev_seq.nextval		,
								v_cd_reclamacao_elementar	,
								v_rec_asw24.cd_fabricante	,
								v_rec_asw24.cd_modelo_veiculo	,
								v_rec_asw24.cd_combustivel	,
								v_rec_asw24.cd_veiculo		,
								v_rec_asw24.cd_ano_veiculo	,
								v_rec_asw24.id_placa		,
								v_rec_asw24.id_veiculo		,
								sysdate				,
								substr(nvl(r1.nm_usuro_alter,
									r1.nm_usuro_incls),
									1,
									20)
								);
						exception
							when others then
								p_mens := 'Falha ao tentar inserir dados na tabela SINISTRO_RECLAMACAO_ELEME_VEIC. Erro: ' ||
									  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;
						end;
					end loop;
					close c3;
				exception
					when others then
						p_mens := 'Problemas ao tentar inserir dados na tabela SINISTRO_RECLAMACAO_ELEME_VEIC. Erro: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
			else
				--
				-- MODO UPDATE
				--
				begin
					open c3 (p_id_aviso_sinst_re_sgrdo);
					loop
						fetch c3 into v_rec_asw24;
						--
						-- CHECA SE HÁ DADOS A TRANSFERIR PARA A TABELA PRINCIPAL
						--
						exit when c3%notfound;
						begin
							select count(1)
							into v_count
							from SINISTRO_RECLAMACAO_ELEME_VEIC
							where
								cd_reclamacao_elementar = v_cd_reclamacao_elementar
							and	id_veiculo = v_rec_asw24.id_veiculo;
						end;
						--
						if v_count = 1 then
							--
							-- PREPARA PARA GERAR HISTÓRICO
							--
							begin
								select  cd_veiculo
								into	v_cd_veiculo_anterior
								from	SINISTRO_RECLAMACAO_ELEME_VEIC
								where
									cd_reclamacao_elementar = v_cd_reclamacao_elementar
								and	id_veiculo = v_rec_asw24.id_veiculo;
							end;
							--
							v_veiculo_anterior := sini4070_010.fnc_retorna_modelo_fipe(
										p_id_veiculo => v_cd_veiculo_anterior,
										p_dt_consulta => trunc(sysdate));
							--
							v_veiculo_atual := sini4070_010.fnc_retorna_modelo_fipe(
										p_id_veiculo => v_rec_asw24.cd_veiculo,
										p_dt_consulta => trunc(sysdate));
							--
							-- ATUALIZA TABELA FINAL
							--
							begin
								update	SINISTRO_RECLAMACAO_ELEME_VEIC
								set
									cd_fabricante  = v_rec_asw24.cd_fabricante,
									cd_modelo_veiculo = v_rec_asw24.cd_modelo_veiculo,
									cd_combustivel = v_rec_asw24.cd_combustivel,
									cd_veiculo = v_rec_asw24.cd_veiculo,
									cd_ano_veiculo = v_rec_asw24.cd_ano_veiculo,
									id_placa = v_rec_asw24.id_placa,
									dt_alteracao = sysdate,
									nm_usuario_alteracao = substr(nvl(r1.nm_usuro_alter,
													r1.nm_usuro_incls),
													1,
													20)
								where
									cd_reclamacao_elementar = v_cd_reclamacao_elementar
								and	id_veiculo = v_rec_asw24.id_veiculo;
							exception
								when others then
									p_mens := 'Problemas ao tentar atualizar dados na tabela SINISTRO_RECLAMACAO_ELEME_VEIC. Erro: ' ||
										  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
									raise v_saida_anormal;
							end;
							--
							-- GERA HISTÓRICO DE ALTERAÇÃO
							--
							if v_veiculo_anterior <> v_veiculo_atual then
								sini2086_002(	p_ds_fase => 'VEICULO ALTERADO DE: ' || v_veiculo_anterior || ' PARA: ' || v_veiculo_atual,
										p_aviso => v_cd_reclamacao_elementar,
										p_id_origem => 2,
										p_cd_letra_sinistro => null,
										p_cd_local_contabil => null,
										p_cd_tipo_bem_segurado => null,
										p_cd_caracteristica_bem_segur => null,
										p_cd_ramo => null,
										p_cd_sinistro => null,
										p_cd_reclamante_sinistro => null,
										p_msgerro => p_mens,
										p_id_consulta_fase_liberada => null,
										p_id_controle_relatorio => null,
										p_cd_fase_padrao => null,
										p_cd_funcionario => REGEXP_REPLACE(nvl(r1.nm_usuro_alter, r1.nm_usuro_incls),'[^[:digit:]]'), -- Só numeros
										p_ultimo_documento => null,
										p_workflow => null,
										p_id_parametro => null,
										p_id_chassi => null);

								if p_mens is not null then
									p_mens:= 'Falha ao gravar histórico de alteração de VEICULO PJ: ' || p_mens;
									raise v_saida_anormal;
								end if;
							end if;
						--
						-- VEÍCULO NOVO, NÃO ENCONTRADO NA TABELA FINAL ANTERIORMENTE
						--
						elsif v_count = 0 then
							begin
								insert into SINISTRO_RECLAMACAO_ELEME_VEIC
									(
									cd_sequencia		,
									cd_reclamacao_elementar ,
									cd_fabricante           ,
									cd_modelo_veiculo	,
									cd_combustivel		,
									cd_veiculo              ,
									cd_ano_veiculo          ,
									id_placa                ,
									id_veiculo		,
									dt_inclusao             ,
									nm_usuario_inclusao
									)
								values
									(
									srev_seq.nextval		,
									v_cd_reclamacao_elementar	,
									v_rec_asw24.cd_fabricante	,
									v_rec_asw24.cd_modelo_veiculo	,
									v_rec_asw24.cd_combustivel	,
									v_rec_asw24.cd_veiculo		,
									v_rec_asw24.cd_ano_veiculo	,
									v_rec_asw24.id_placa		,
									v_rec_asw24.id_veiculo		,
									sysdate				,
									substr(nvl(r1.nm_usuro_alter,
										r1.nm_usuro_incls),
										1,
										20)
									);
							exception
								when others then
									p_mens := 'Problemas ao tentar inserir dados na tabela SINISTRO_RECLAMACAO_ELEME_VEIC. Erro: ' ||
										  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
									raise v_saida_anormal;
							end;
						else
							p_mens := 'Mais de um veículo com o mesmo ID e CD_RECLAMACAO_ELEMENTAR encontrados para: ' || v_cd_reclamacao_elementar
								|| ' ID: ' || v_rec_asw24.id_veiculo;
							raise v_saida_anormal;
						end if;
						--
					end loop;
					--
					-- EM CASO DE VEÍCULOS REMOVIDOS, DELETE DA TABELA FINAL E GERE HISTÓRICO
					--
					v_rowcount := c3%rowcount;
					open c4 (v_cd_reclamacao_elementar, v_rowcount);
					loop
						fetch c4 into v_rec_srev;
						exit when c4%notfound;
						--
						v_veiculo_anterior := sini4070_010.fnc_retorna_modelo_fipe(
									p_id_veiculo => v_rec_srev.cd_veiculo,
									p_dt_consulta => trunc(sysdate));
						--
						begin
							delete SINISTRO_RECLAMACAO_ELEME_VEIC
							where
								cd_reclamacao_elementar = v_cd_reclamacao_elementar
							and	id_veiculo = v_rec_srev.id_veiculo;
						end;
						--
						-- GERA HISTÓRICO DE ALTERAÇÃO
						--
						sini2086_002(	p_ds_fase => 'VEICULO EXCLUÍDO: ' || v_veiculo_anterior,
								p_aviso => v_cd_reclamacao_elementar,
								p_id_origem => 2,
								p_cd_letra_sinistro => null,
								p_cd_local_contabil => null,
								p_cd_tipo_bem_segurado => null,
								p_cd_caracteristica_bem_segur => null,
								p_cd_ramo => null,
								p_cd_sinistro => null,
								p_cd_reclamante_sinistro => null,
								p_msgerro => p_mens,
								p_id_consulta_fase_liberada => null,
								p_id_controle_relatorio => null,
								p_cd_fase_padrao => null,
								p_cd_funcionario => REGEXP_REPLACE(nvl(r1.nm_usuro_alter, r1.nm_usuro_incls),'[^[:digit:]]'), -- Só numeros
								p_ultimo_documento => null,
								p_workflow => null,
								p_id_parametro => null,
								p_id_chassi => null);

						if p_mens is not null then
							p_mens:= 'Falha ao gravar histórico de exclusão de VEICULO PJ: ' || p_mens;
							raise v_saida_anormal;
						end if;
						--
					end loop;
					close c4;
					close c3;
					--
				exception
					when others then
						p_mens := 'Problemas ao tentar atualizar dados na tabela SINISTRO_RECLAMACAO_ELEME_VEIC. Erro: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
			end if;
			--
			-- busca dados do transportador na tabela temporaria e insere/atualiza na tabela final
			begin

				if v_insere and
				  (r1.id_placa_transportador is not null or
				   r1.vl_embarque is not null or
				   r1.dt_ctrc is not null or
				   r1.ds_origem is not null or
				   r1.ds_destino is not null or
				   r1.nm_transportadora is not null or
				   r1.cd_chassi is not null)
				then
					begin
						insert into SINISTRO_INFO_COMPLEMENTAR
								(
								ID_SEQ_INFO_COMPL_SINISTRO,
								CD_RECLAMACAO_ELEMENTAR,
								id_placa,
								vl_embarque,
								dt_ctrc,
								ds_origem,
								ds_destino,
								nm_transportadora,
								id_chassi_transportador,
								dt_inclusao,
								NM_USUARIO_INCLUSAO,
								dt_alteracao,
								nm_usuario_alteracao
								)
						values
								(
								SEQ_INFO_COMPL_SINISTRO.nextval,
								v_cd_reclamacao_elementar,
								r1.id_placa_transportador,
								r1.vl_embarque,
								r1.dt_ctrc,
								r1.ds_origem,
								r1.ds_destino,
								r1.nm_transportadora,
								r1.cd_chassi,
								sysdate,
								substr(nvl(r1.nm_usuro_alter,r1.nm_usuro_incls),1,20),
								sysdate,
								substr(nvl(r1.nm_usuro_alter,r1.nm_usuro_incls),1,20)
								);
					exception
						when others then
							p_mens:= 'Falha ao tentar inserir dados na tabela SINISTRO_INFO_COMPLEMENTAR. Erro: ' ||
								DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
				else
					begin
						update SINISTRO_INFO_COMPLEMENTAR
						set
								id_placa = r1.id_placa_transportador
								,vl_embarque = r1.vl_embarque
								,dt_ctrc = r1.dt_ctrc
								,ds_origem = r1.ds_origem
								,ds_destino = r1.ds_destino
								,nm_transportadora = r1.nm_transportadora
								,id_chassi_transportador = r1.cd_chassi
								,dt_alteracao = sysdate
								,nm_usuario_alteracao = substr(nvl(r1.nm_usuro_alter,r1.nm_usuro_incls),1,20)
						where
								CD_RECLAMACAO_ELEMENTAR = v_cd_reclamacao_elementar;
					exception
						when others then
							p_mens:= 'Falha ao tentar inserir dados na tabela SINISTRO_INFO_COMPLEMENTAR. Erro: ' ||
								DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
				end if;
			exception
				when others then
					p_mens:= 'Problemas ao tentar inserir dados na tabela SINISTRO_INFO_COMPLEMENTAR. Erro: ' ||
						DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			--
			--insere terceiros
			if v_insere then
				for r2 in c2 loop
					begin
						select seq_terceiro.nextval
						  into v_cd_terceiro_sinistro
						  from dual;
					exception
						when others then
							p_mens := 'Erro ao acessar a sequence seq_terceiro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
					--
					begin
						if r2.id_tipo_pessoa_terc = 'F' then
							v_cpf_cnpj_terceiro := substr(lpad(r2.nr_cpf_cnpj_terc,
											   11,
											   0),
										      1,
										      9);
							v_digito_terceiro   := substr(lpad(r2.nr_cpf_cnpj_terc,
											   11,
											   0),
										      10,
										      2);
						elsif r2.id_tipo_pessoa_terc = 'J' then
							v_cpf_cnpj_terceiro        := substr(lpad(r2.nr_cpf_cnpj_terc,
												  14,
												  0),
											     1,
											     8);
							v_estabelecimento_terceiro := substr(lpad(r2.nr_cpf_cnpj_terc,
												  14,
												  0),
											     9,
											     4);
							v_digito_terceiro          := substr(lpad(r2.nr_cpf_cnpj_terc,
												  14,
												  0),
											     13,
											     2);
						else
							p_mens := 'Tipo de pessoa ' ||
								  r2.id_tipo_pessoa_terc ||
								  ' invlido.';
							raise v_saida_anormal;
						end if;
					exception
						when others then
							p_mens := 'Problemas ao tentar formatar CPF/CNPJ ' ||
								  r2.id_tipo_pessoa_terc ||
								  ' - ' ||
								  r2.nr_cpf_cnpj_terc ||
								  '. Erro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
					--
					begin
						insert into sinistro_terceiro
							(cd_terceiro_sinistro,
							 nm_terceiro,
							 id_tipo_terceiro,
							 nr_cnpj_cpf_terceiro,
							 nr_estabelecimento_terceiro,
							 nr_digito_verificador,
							 id_situacao_pessoa,
							 id_local_domicilio,
							 nr_ddd_residencial,
							 nr_telefone_residencial,
							 nr_ddd_celular,
							 nr_celular,
							 nm_usuario_inclusao,
							 dt_inclusao)
						values
							(v_cd_terceiro_sinistro, --cd_terceiro_sinistro            ,
							 r2.nm_terceiro, --nm_terceiro                     ,
							 r2.id_tipo_pessoa_terc, --id_tipo_terceiro                ,
							 v_cpf_cnpj_terceiro, --nr_cnpj_cpf_terceiro            ,
							 v_estabelecimento_terceiro, --nr_estabelecimento_terceiro     ,
							 v_digito_terceiro, --nr_digito_verificador           ,
							 1, --id_situacao_pessoa              ,
							 1, --id_local_domicilio              ,
							 r2.nr_ddd_contato,
							 r2.nr_telefone_contato,
							 r2.nr_ddd_cel_terceiro,
							 r2.nr_tel_cel_terceiro,
							 substr(nvl(r1.nm_usuro_alter,
								    r1.nm_usuro_incls),
								1,
								20), --nm_usuario_inclusao             ,
							 sysdate --dt_inclusa
							 );
					exception
						when others then
							p_mens := 'Problemas ao tentar incluir registro na tabela SINISTRO_TERCEIRO. Erro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
					--
					begin
						select nvl(max(cd_terceiro_sinistro_eleme),
							   0) + 1
						  into v_cd_terceiro_sinistro_eleme
						  from sinis_reclamacao_eleme_terce
						 where cd_reclamacao_elementar =
						       v_cd_reclamacao_elementar;
					exception
						when others then
							p_mens := 'Problemas ao selecionar sinis_reclamacao_eleme_terce - Erro : ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
					--
					begin
						insert into sinis_reclamacao_eleme_terce
							(cd_reclamacao_elementar,
							 cd_terceiro_sinistro_eleme,
							 cd_terceiro_sinistro,
							 id_cep_ocorrencia,
							 ds_local_ocorrencia,
							 nm_bairro_ocorrencia,
							 nm_municipio_ocorrencia,
							 id_unidade_federacao_ocorr,
							 id_outro_bem,
							 id_possui_bo,
							 nm_usuario_inclusao,
							 dt_inclusao,
							 id_email_terceiro,
							 ds_bens,
							 nr_local_ocorrencia)
						values
							(v_cd_reclamacao_elementar,
							 v_cd_terceiro_sinistro_eleme,
							 v_cd_terceiro_sinistro,
							 r2.id_cep_ocorrencia,
							 r2.ds_local_ocorrencia,
							 r2.nm_bairro_ocorrencia,
							 r2.nm_municipio_ocorrencia,
							 r2.id_unidade_federacao_ocorr,
							 'S',
							 'N',
							 substr(nvl(r1.nm_usuro_alter,
								    r1.nm_usuro_incls),
								1,
								20),
							 sysdate,
							 r2.id_email_terceiro,
							 r2.ds_bens,
							 r2.nr_local_ocorrencia);
					exception
						when others then
							p_mens := 'Problemas ao tentar incluir registro na tabela SINIS_RECLAMACAO_ELEME_TERCE. Erro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
				end loop;
			end if;
			--
			v_lixo_varchar := null;
			v_lixo_date    := null;
			v_operacao     := 'I';
			--
			if	r1.id_situacao_imovel	is	not	null	then
				--
				begin
				update	asw0016_aviso_sinst_re_sgrdo	a
				set	a.nr_aviso	=	v_cd_reclamacao_elementar
				where	a.id_aviso_sinst_re_sgrdo	=	p_id_aviso_sinst_re_sgrdo;
				exception
					when	others	then
						--
						null;
						--
				end;
				--
			end	if;
			--
			commit;

			begin
				sini7070_006.do_key_commit_02(v_cd_reclamacao_elementar,
							      --p_cd_reclamacao_elementar        in        number
							      v_cd_vistoriador_sinistro,
							      --p_cd_vistoriador_sinistro        in        number
							      v_cd_apolice,
							      --p_cd_apolice                in        number
							      v_cd_sinistro,
							      --p_id_sinistro            in    out    number
							      v_st_registro,
							      --p_st_registro            in    out    number
							      'I',
							      --p_id_chamada                in        varchar2
							      v_aviso_sem_apolice,
							      --p_aviso_sem_apolice            in    out    number
							      'N',
							      --p_desativa_rel_email            in        varchar2
							      'S',
							      --p_id_workflow            in        varchar2
							      v_operacao,
							      --p_operacao                in    out    varchar2
							      case when v_cd_reclamacao_elementar is null then null else sysdate end,
                    --p_dt_alteracao            in        date
                    case when v_cd_reclamacao_elementar is null then null else substr(nvl(r1.nm_usuro_alter,r1.nm_usuro_incls),1,20) end,
                    --p_nm_usuario_alteracao        in        varchar2
							      'N',
							      --p_id_rollout                in        varchar2
							      v_id_situacao,
							      --p_id_situacao            in        number
							      v_cd_local,
							      --p_cd_local                in        number
							      r1.cd_ramo_cobertura,
							      --p_cd_ramo                in    out    number
							      r1.cd_tipo_bem_segrdo,
							      --p_cd_tipo_bem_segurado        in        number
							      r1.cd_carac_bem_segrdo,
							      --p_cd_caracteristica_bem_segur    in        number
							      v_cd_ramo_apolice,
							      --p_cd_ramo_apolice            in        number
							      v_cd_item_apolice,
							      --p_cd_item_apolice            in        number
							      v_cd_produto_historico,
							      --p_cd_produto_historico        in        number
							      v_cd_produto_arquivo,
							      --p_cd_produto_arquivo            in        number
							      v_cd_produto,
							      --p_cd_produto                in        number
							      r1.id_cober_sinis,
							      --p_cd_cobertura            in        number
							      v_cd_produto_tmsr,
							      --p_cd_produto_tmsr            in        number
							      r1.id_tipo_ocorr_sinis,
							      --p_cd_natureza_sinistro        in        number
							      r1.dt_ocorrencia,
							      --p_dt_ocorrencia            in        date
							      1,
							      --p_id_tipo_processo            in        number
							      r1.cd_sgrdo,
							      --p_cd_segurado_tela            in    out    number
							      'N',
							      --p_id_usuario_assistencia        in        varchar2
							      v_vl_estimativa_prejuizo,
							      --p_vl_estimativa_prejuizo        in        number
							      v_id_necessidade_vistoria,
							      --p_id_necessidade_vistoria        in        varchar2
							      v_id_tipo_operacao,
							      --p_id_tipo_operacao            in        number
							      sysdate,
							      --p_dt_inclusao            in        date
							      v_cd_funcionario,
							      --p_cd_funcionario            in        number
							      null,
							      --p_cd_cobertura_ant            in        number
							      'N',
							      --p_id_terceiro            in        varchar2
							      v_cd_letra_sinistro,
							      --p_cd_letra_sinistro            in    out    varchar2
							      v_cd_local_contabil,
							      --p_cd_local_contabil            in    out    number
							      v_cd_reclamante_sinistro,
							      --p_cd_reclamante_sinistro        in    out    number
							      null,
							      --p_dsp_cd_terceiro_sinistro        in        number
							      v_id_situacao_abertura,
							      --p_id_situacao_abertura        in    out    varchar2
							      null,
							      --p_id_rollout_ant            in        varchar2
							      null,
							      --p_nm_vistoriador_sinistro        in        varchar2
							      null,
							      --p_cd_workflow_pi            in        number
							      null,
							      --p_cd_workflow_wi            in        number
							      null,
							      --p_cd_workflow_choice            in        varchar2
							      v_lixo_varchar,
							      --p_role_usuario                out    varchar2
							      null,
							      --p_cd_vistoriador_sinistro_ant    in        number
							      null,
							      --p_nm_vistoriador_sinistro_ant    in        varchar2
							      null,
							      --p_vl_estimativa_prej_ant        in        number
							      r1.cd_envia_sms_contt,
							      --p_id_receber_sms                   in          varchar2
					              nvl(r1.nr_ddd_celul_sgrdo,r1.nr_ddd_celul_contt), --number(4),
                				  --  r1.nr_ddd_celul_sgrdo,
							      --p_nr_ddd_sms                       in          number
					              nvl(r1.nr_telef_celul_sgrdo,r1.nr_telef_celul_contt), --number(13),
                                  --  r1.nr_telef_celul_sgrdo,
							      --p_nr_celular_sms                   in          number
							      r1.cd_cia_sgdra,
							      --p_cd_cia_seguradora                in              number
							      v_id_ramo_produto_tmsr,
							      --p_id_ramo_produto_tmsr             in          number
							      v_id_apolice_tmsr,
							      --p_id_apolice_tmsr                  in          number
							      v_id_tipo_endosso_tmsr,
							      --p_id_tipo_endosso_tmsr             in          number
							      v_id_endosso_tmsr,
							      --p_id_endosso_tmsr                  in          number
							      v_id_item_tmsr,
							      --p_id_item_tmsr                     in          number
							      v_lixo_varchar,
							      --p_mens_ref_abertura                out    varchar2
							      v_lixo_varchar,
							      --p_mens_ref_workflow                out    varchar2
							      v_lixo_varchar,
							      --p_mens_ref_historico                out    varchar2
							      v_lixo_varchar,
							      --p_id_analista_distr_vist            out    varchar2
							      'O',
							      --p_cd_tipo_bem_danificado        in        varchar2
							      'N',
							      --p_cd_sini_planilha            in        varchar2
							      'S',
							      --p_aviso_web                in        varchar2
							      nvl(r1.id_perfil_usuario,'I'),  -- nvl SinistroDigitalResidencial
							      --p_id_perfil_usuario            in        varchar2
							      v_cd_tipo_vistoria_sinistro,
							      p_mens,
							      --p_mens                    out    varchar2
							      case when v_insere then 'S' else 'N' end--SSIN 3603
							      );
			exception
				when others then
					p_mens := 'Problemas na chamada da rotina SINI7070_006.DO_KEY_COMMIT_02. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			if p_mens is not null then
				raise v_saida_anormal;
			end if;
			-- SSIN 3786: FIANÇA CHECKLIST
			for	r5	in	c5	loop
				--
				begin
					--
					insert	into	sinistro_reclamacao_eleme_cob	(
											cd_sequencia,
											cd_reclamacao_elementar,
											cd_tipo_bem_segurado,
											cd_caracteristica_bem_segur,
											cd_ramo,
											cd_cobertura_basica,
											cd_cobertura_adicional,
											cd_tipo_debito,
											dt_vencimento,
											vl_reclamado,
											ds_observacao,
											nm_usuario_inclusao,
											dt_inclusao,
											nm_usuario_alteracao,
											dt_alteracao
											)
					values						(
											seq_sinistro_reclama_ele_cob.nextval,
											v_cd_reclamacao_elementar,
											r1.cd_tipo_bem_segrdo,
											r1.cd_carac_bem_segrdo,
											r1.cd_ramo_cobertura,
											r5.cd_cobertura_basica,
											r5.cd_cobertura_adicional,
											r5.cd_tipo_debito,
											r5.dt_vencimento,
											r5.vl_reclamado,
											r5.ds_observacao,
											substr(nvl(r1.nm_usuro_alter,r1.nm_usuro_incls),1,20),
											sysdate,
											null,
											null
											);
					--
				exception
					when	others	then
						--
						p_mens	:=	'Problemas ao tentar incluir registro na tabela SINISTRO_RECLAMACAO_ELEME_COB. Erro: ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise	v_saida_anormal;
						--
				end;
				--
				v_existe_checklist	:=	'S';
				--
			end	loop;
			--
			if	v_cd_sinistro	is	not	null	and	nvl(v_existe_checklist,'N')	=	'S'	then
				--
				begin
					--
					gp_compl_imovel_0003.prc_gera_adiantamento_aviso(v_cd_reclamacao_elementar,p_id_aviso_sinst_re_sgrdo,v_cd_checklist,p_mens);
					--
				exception
					when	others	then
						--
						p_mens	:=	'Erro ao tentar gerar Checklist [GP_COMPL_IMOVEL_0003.PRC_GERA_ADIANTAMENTO_AVISO]. Erro: ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise	v_saida_anormal;

						--
				end;
				--
				if	p_mens	is	not	null	then
					--
					raise	v_saida_anormal;
					--
				end	if;
				--
			end	if;
			--
			-- FIM SSIN 3786: FIANÇA CHECKLIST
			--
			begin
				select b.id_email
				  into v_id_email_analista
				  from sinistro_analista a, funcionario b
				 where a.cd_analista_sinistro =
				       v_cd_analista_sinistro
				   and a.cd_funcionario = v_cd_funcionario
				   and a.cd_funcionario = b.cd_funcionario;
			exception
				when others then
					v_id_email_analista := null;
			end;
			begin
				select a.cd_vistoriador_sinistro
				  into v_cd_vistoriador_sinistro
				  from sinistro_reclamacao_eleme a
				 where a.cd_reclamacao_elementar =
				       v_cd_reclamacao_elementar;
			exception
				when others then
					null;
			end;
			begin
				select s.nm_vistoriador, s.id_email
				  into v_nm_vistoriador_sinistro,
				       v_id_email_vistoriador
				  from sinistro_vistoriador s
				 where s.cd_vistoriador_sinistro =
				       v_cd_vistoriador_sinistro;
			exception
				when others then
					v_nm_vistoriador_sinistro := null;
					v_id_email_vistoriador    := null;
			end;
			--
			if	v_insere	then
			-- PROCEDURE QUE GERA OS RELATRIOS E ENVIA E-MAIL.
			begin
				--
				select	a.vl_char
				into	v_liga
				from	politicas_parametro	a
				where	a.nm_politica_parametro	=	'LIGA_7070_008_BATCH_REL';
				--
			exception
				when	others	then
					--
					v_liga	:=	'N';
					--
			end;
			--
			if	v_liga	=	'N'	then

				-- PROCEDURE QUE GERA OS RELATRIOS E ENVIA E-MAIL.
				begin
					sini7070_006.post_db_commit(v_cd_reclamacao_elementar,
								    --p_cd_reclamacao_elementar    in         number
								    'S',
								    --p_p_inclusao            in        varchar2
								    v_id_sistema_origem,
								    --p_id_sistema_origem        in        number
								    v_cd_corretor,
								    --p_cd_corretor            in        number
								    v_id_achou_apolice,
								    --p_id_achou_apolice        in        varchar2
								    'N',
								    --p_id_rollout            in        varchar2
								    v_id_tipo_operacao,
								    --p_p_id_tipo_operacao        in        number
								    v_id_existe_email_corretor,
								    --p_id_existe_email_corretor    in        varchar2
								    'N',
								    --p_p_desativa_rel_email    in        varchar2
								    v_lixo_varchar,
								    --p_p_sini7080            in    out    varchar2
								    v_cd_local_contabil,
								    --p_id_local_contabil        in                 number
								    r1.cd_tipo_bem_segrdo,
								    --p_cd_tipo_bem_segurado        in        number
								    r1.cd_carac_bem_segrdo,
								    --p_cd_caracteristica_bem_segur    in        number
								    r1.cd_ramo_cobertura,
								    --p_id_ramo                     in        number
								    v_cd_sinistro,
								    --p_id_sinistro                 in        number
								    v_id_situacao,
								    --p_id_situacao            in        number
								    v_cd_endosso,
								    --p_cd_endosso            in    out    number
								    v_cd_produto,
								    --p_cd_produto                  in    out    number
								    v_cd_produto_arquivo,
								    --p_cd_produto_arquivo        in    out    number
								    v_cd_produto_historico,
								    --p_cd_produto_historico        in    out    number
								    v_cd_produto_tmsr,
								    --p_cd_produto_tmsr             in    out    number
								    r1.cd_cia_sgdra,
								    --p_cd_cia_seguradora        in        number
								    v_cd_ramo_apolice,
								    --p_cd_ramo                 in        number
								    v_cd_local,
								    --p_cd_local                in        number
								    v_cd_apolice,
								    --p_cd_apolice              in        number
								    v_cd_item_apolice,
								    --p_cd_item_apolice         in        number
								    v_cd_ramo_apolice,
								    --p_cd_ramo_apolice         in        number
								    v_id_apolice_tmsr,
								    --p_id_apolice_tmsr         in        number
								    v_id_tipo_endosso_tmsr,
								    --p_id_tipo_endosso_tmsr    in        number
								    v_id_endosso_tmsr,
								    --p_id_endosso_tmsr         in        number
								    v_id_item_tmsr,
								    --p_id_item_tmsr            in        number
								    v_id_ramo_produto_tmsr,
								    --p_id_ramo_produto_tmsr    in        number
								    r1.dt_ocorrencia,
								    --p_dt_ocorrencia           in        date
								    r1.dt_arquv,
								    --p_dt_historico_arquivo    in    out    date
								    v_cd_letra_sinistro,
								    --p_id_letra_sinistro        in        varchar2
								    v_lixo_varchar,
								    --p_p_sini8150            in    out    varchar2
								    v_lixo_varchar,
								    --p_p_sini4205            in    out    varchar2
								    'S',
								    --p_g_enviar_email_analista    in        varchar2
								    v_lixo_varchar,
								    --p_ds_mensagem_corretor    in        varchar2
								    v_id_email_analista,
								    --p_id_email_analista        in        varchar2
								    v_cd_vistoriador_sinistro,
								    --p_cd_vistoriador_sinistro    in        number
								    v_id_situacao_abertura,
								    --p_id_situacao_abertura    in        varchar2
								    v_nm_vistoriador_sinistro,
								    --p_nm_vistoriador_sinistro    in    out    varchar2
								    v_id_email_vistoriador,
								    --p_id_email_vistoriador    in    out    varchar2
								    v_cd_funcionario,
								    --p_cd_funcionario        in        number
								    v_cd_analista_sinistro,
								    --p_cd_analista_sinistro    in        number
								    1,
								    --p_id_tipo_processo        in        number
								    v_lixo_varchar,
								    --p_id_analista_distr_vist    in        varchar2
								    v_st_registro,
								    --p_g_st_registro        in    out    number
								    'S',
								    --p_aviso_web
								    r1.id_tipo_ocorr_sinis,
								    --p_cd_natureza
								    p_mens,
								    --p_mens                out    varchar2
								    v_lixo_varchar,
								    --p_mens_aviso                out    varchar2
								    v_lixo_varchar,
								    --p_mens_aviso_2            out    varchar2
								    v_lixo_varchar,
								    --p_mens_aviso_3            out    varchar2
								    v_lixo_varchar,
								    --p_mens_aviso_4                        out    varchar2
								    v_lixo_varchar
								    --p_mens_aviso_5                        out    varchar2
								    );
				exception
					when others then
						p_mens := 'Problemas ao executar procedure SINI7070_006.POST_DB_COMMIT. ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				--
				--## (SS-1420) envia e-mail no formato GNT com checklist de rc ambiental ##
				begin
					--SS-1661
					if r1.cd_ramo_cobertura = 13 then
						-- busca os dados para o envio do e-mail
						begin
							--
							select a.ds_observacao,
							       a.id_email_segurado,
							       a.dt_ocorrencia,
							       a.nm_informante_reclamacao,
							       c.nm_segurado,
							       c.nr_cgc_cpf_segurado,
							       c.nr_estabelecimento_segurado,
							       c.nr_digito_verificador,
							       a.nr_ddd_segurado,
							       a.nr_telefone_segurado,
							       a.ds_endereco_vistoria,
							       a.nm_bairro_vistoria,
							       a.nm_municipio_vistoria,
							       a.id_unidade_federacao_vistor,
							       a.ds_ocorrencia,
							       a.cd_benefsinis_assistencia,
							       e.nm_beneficiario,
							       h.id_email,
							       a.nm_outro_prest_assistencia,
							       a.id_email_prest_assistencia,
							       b.cd_apolice
							  into vrc_ds_observacao,
							       vrc_id_email_segurado,
							       vrc_dt_ocorrencia,
							       vrc_nm_informante_reclamacao,
							       vrc_nm_segurado,
							       vrc_nr_cgc_cpf_segurado,
							       vrc_nr_estab_segurado,
							       vrc_nr_digito_verificador,
							       vrc_nr_ddd_segurado,
							       vrc_nr_telefone_segurado,
							       vrc_ds_local_ocorrencia,
							       vrc_nm_bairro_ocorrencia,
							       vrc_nm_municipio_ocorrencia,
							       vrc_id_unidade_federacao_ocorr,
							       vrc_ds_ocorrencia,
							       vrc_cd_benefsinis_assistencia,
							       vrc_nm_beneficiario,
							       vrc_id_email,
							       vrc_nm_outro_prest_assistencia,
							       vrc_id_email_prest_assistencia,
							       vcr_noapolice
							  from sinistro_reclamacao_eleme     a,
							       sin_apolice_item              b,
							       sin_segurado                  c,
							       sinistro_natureza             d,
							       sinistro_beneficiario         e,
							       sinistro_beneficiario_contato f,
							       sinistro_benef_contato_telef  g,
							       sinistro_benef_contato_email  h
							 where a.id_apolice_tmsr =
							       b.cd_apolice
							   and a.id_endosso_tmsr =
							       b.cd_endosso
							   and a.id_item_tmsr =
							       b.cd_item_apolice
							   and b.cd_segurado =
							       c.cd_segurado
							   --
							   and b.cd_sistema_origem =
							       c.cd_sistema_origem
							   --
							   and b.cd_ramo_produto =
							       r1.cd_ramo_apoli
							   and a.cd_natureza_sinistro =
							       d.cd_natureza_sinistro
							   and a.cd_benefsinis_assistencia =
							       e.cd_beneficiario_sinistro(+)
							   and e.cd_beneficiario_sinistro =
							       f.cd_beneficiario_sinistro(+)
							   and f.cd_benef_contato_sinistro =
							       g.cd_benef_contato_sinistro(+)
							   and g.cd_benef_contato_sinistro =
							       h.cd_benef_contato_sinistro(+)
							   and a.cd_reclamacao_elementar =
							       v_cd_reclamacao_elementar;
							--
							if	v_id_email_analista	is	not	null	then
								--
								vrc_destinatario := v_id_email_analista;
								--
								if	vrc_id_email_prest_assistencia	is	not	null	then
									--
									vrc_destinatario	:=	vrc_destinatario||';'||vrc_id_email_prest_assistencia;
									--
								end	if;
								--
							else
								vrc_destinatario := vrc_id_email_prest_assistencia;
								--
							end if;
							--
						exception
							--
							when others then
								p_mens := 'Problemas ao consultar tabela sinistro_reclamacao_eleme. Erro: ' ||
									  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;

							--
						end;
						--

						-- chama a proc de envio de e-mail
						if	vrc_destinatario	is	not	null	then
							--
						begin
							--
							sini7070_008.prc_email_rc_ambiental(v_cd_reclamacao_elementar,
											    vrc_ds_observacao,
											    vrc_destinatario,
											    vrc_dt_ocorrencia,
											    vrc_nm_informante_reclamacao,
											    vrc_nm_segurado,
											    vrc_nr_cgc_cpf_segurado ||
											    to_char(vrc_nr_estab_segurado,
												    '0000') ||
											    to_char(vrc_nr_digito_verificador,
												    '00'),
											    vrc_id_email_segurado,
											    vrc_nr_ddd_segurado ||
											    vrc_nr_telefone_segurado,
											    null,
											    vrc_ds_local_ocorrencia || ', ' ||
											    vrc_nm_bairro_ocorrencia || ', ' ||
											    vrc_nm_municipio_ocorrencia || ', ' ||
											    vrc_id_unidade_federacao_ocorr,
											    null,
											    vrc_ds_ocorrencia,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    vcr_noapolice,
											    vrc_retorno,
											    vrc_msg);

							if vrc_msg is not null then
								p_mens := 'SINI7070_008.prc_email_rc_ambiental - Erro durante a execuo' ||
									  vrc_msg;
								raise v_saida_anormal;
							end if;

							--
						exception
							--
							when others then
								p_mens := 'SINI7070_008.prc_email_rc_ambiental - Erro geral: ' ||
									  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise v_saida_anormal;
								--
						end;
						--
					end if;
						--
					end	if;
					--
				end;
				--
			else
				--
				begin
					--
					insert	into	sinistro_relatorios(cd_aviso, cd_ramo, id_tipo_operacao,id_existe_email_corretor,id_email_analista,id_situacao_abertura,cd_vistoriador_sinistro,nm_vistoriador_sinistro,id_email_vistoriador,st_registro,id_extracao, dt_extracao, dt_inclusao, nm_usuario_inclusao)
					values	(v_cd_reclamacao_elementar,r1.cd_ramo_cobertura,v_id_tipo_operacao,v_id_existe_email_corretor, v_id_email_analista,v_id_situacao_abertura,v_cd_vistoriador_sinistro,v_nm_vistoriador_sinistro,v_id_email_vistoriador,v_st_registro,'N',null,sysdate,user);
					--
				exception
					when others then
						p_mens := 'Problemas ao tentar inserir na tabela SINISTRO_RELATORIOS. Erro: ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				end;
				--
				commit;
				--
			end	if;
			--
			end	if;
			begin
				select	distinct 'S'
				into	v_id_dados_riscos_digitais
				from	sin_aviso_riscos_digitais	a
				where	a.id_aviso_sinst_re_sgrdo	= p_id_aviso_sinst_re_sgrdo;

			exception
				when others then
					v_id_dados_riscos_digitais	:= 'N';
			end;

			if	v_id_dados_riscos_digitais	= 'S'	then

				--
				begin
					update	sin_aviso_riscos_digitais	a
					set	a.cd_reclamacao_elementar	= v_cd_reclamacao_elementar,
						a.cd_ramo			= r1.cd_ramo_cobertura
					where	a.id_aviso_sinst_re_sgrdo	= p_id_aviso_sinst_re_sgrdo;

				exception
					when others then
						p_mens := 'Problemas ao atualizar dados de Riscos Digitais. Erro: ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				end;
				--

			end if;
			--
			begin
				update sin_reclamante_judicial srj
				set	srj.cd_aviso = v_cd_reclamacao_elementar
				where	srj.id_aviso_sinst_re_sgrdo = p_id_aviso_sinst_re_sgrdo;
			exception
				when others then
					p_mens:= 'Falha ao atualizar SIN_RECLAMANTE_JUDICIAL: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			end;
			--


		end loop;
		--
		begin
			delete asw0017_terceiro_re a
			 where a.id_aviso_sinst_re_sgrdo =
			       p_id_aviso_sinst_re_sgrdo;
		exception
			when others then
				p_mens := 'Problemas ao tentar limpar asw0017_terceiro_re. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
		end;
		--
		-- INICIO SSIN 3786: FIANÇA CHECKLIST
		--
		/*begin
			delete asw0025_aviso_sinst_re_cober a
			 where a.id_aviso_sinst_re_sgrdo =
			       p_id_aviso_sinst_re_sgrdo;
		exception
			when others then
				p_mens := 'Problemas ao tentar limpar ASW0025_AVISO_SINST_RE_COBER. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
		end;
		--
		begin
			delete asw0026_aviso_sinst_re_gar a
			 where a.id_aviso_sinst_re_sgrdo =
			       p_id_aviso_sinst_re_sgrdo;
		exception
			when others then
				p_mens := 'Problemas ao tentar limpar ASW0026_AVISO_SINST_RE_GAR. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
		end;
		--
		-- FIM SSIN 3786: FIANÇA CHECKLIST
		--
		begin
			delete asw0016_aviso_sinst_re_sgrdo a
			 where a.id_aviso_sinst_re_sgrdo =
			       p_id_aviso_sinst_re_sgrdo;
		exception
			when others then
				p_mens := 'Problemas ao tentar limpar asw0016_aviso_sinst_re_sgrdo. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
		end;*/
		--
		begin
			delete asw0024_aviso_sinst_re_veic a
			 where a.cd_reclamacao_elementar =
			       p_id_aviso_sinst_re_sgrdo;
		exception
			when others then
				p_mens := 'Problemas ao tentar limpar asw0024_aviso_sinst_re_veic. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
		end;
		--
		p_id_aviso_sinst_re_sgrdo := v_cd_reclamacao_elementar;
		--
		commit;
		--
	exception
		when v_saida_anormal then
			p_mens := 'SINI7070_008.PRC_FINALIZA_AVISO_RE - ' ||
				  p_mens;
			return;
		when others then
			p_mens := 'SINI7070_008.PRC_FINALIZA_AVISO_RE - Erro geral: ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			return;
	end prc_finaliza_aviso_re;

	/***********************************************************************************
        fnc_verifica_ramo_asw
            Author  : Paulo H. Garcia
            Created : 19/05/2012
            Purpose : Rotina responsavel por validar se o ramo escolhido pode ser avisado pela
                      web.
        ***********************************************************************************/
	function fnc_verifica_ramo_asw(p_cd_tipo_bem_segurado in number,
				       p_cd_caract_bem_segur  in number,
				       p_cd_ramo              in number,
				       p_id_perfil            in varchar2,
				       p_mens                 out varchar2)
		return varchar2 is
		--
		v_libera_interno    varchar2(1) := 'N';
		v_libera_callcenter varchar2(1) := 'N';
		v_libera_externo    varchar2(1) := 'N';
		--
	begin
		begin
			select slrw.id_abertura_interno,
			       slrw.id_abertura_callcenter,
			       slrw.id_abertura_externo
			  into v_libera_interno,
			       v_libera_callcenter,
			       v_libera_externo
			  from sinistro_liberacao_ramo_web slrw
			 where slrw.cd_tipo_bem_segurado =
			       p_cd_tipo_bem_segurado
			   and slrw.cd_caracteristica_bem_segur =
			       p_cd_caract_bem_segur
			   and slrw.cd_ramo = p_cd_ramo;
		exception
			when no_data_found then
				v_libera_interno    := 'N';
				v_libera_callcenter := 'N';
				v_libera_externo    := 'N';
				return 'N';
			when others then
				p_mens := 'Erro ao tentar verificar se o ramo escolhido pode ser aberto pela Web. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				return 'N';
		end;
		if p_id_perfil = 'I' then
			--interno
			return v_libera_interno;
		elsif p_id_perfil = 'C' then
			--callcenter
			return v_libera_callcenter;
		elsif p_id_perfil = 'E' then
			--externo
			return v_libera_externo;
		end if;
	exception
		when others then
			p_mens := 'SINI7070_008.FNC_VERIFICA_RAMO_ASW - Erro Geral - ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			return 'N';
	end;

	/***********************************************************************************
        prc_inclui_altera_terceiro
            Author  : Paulo H. Garcia
            Created : 26/05/2012
            Purpose : Rotina responsavel por incluir/alterar terceiros do aviso de RE
        ***********************************************************************************/
	procedure prc_inclui_altera_terceiro(p_id_aviso_sinst_re_sgrdo    in number,
					     p_id_tipo_pessoa_terc        in varchar2,
					     p_nr_cpf_cnpj_terc           in number,
					     p_nm_terceiro                in varchar2,
					     p_id_cep_ocorrencia          in number,
					     p_ds_local_ocorrencia        in varchar2,
					     p_nr_local_ocorrencia        in varchar2,
					     p_nm_bairro_ocorrencia       in varchar2,
					     p_nm_municipio_ocorrencia    in varchar2,
					     p_id_unidade_federacao_ocorr in varchar2,
					     p_nr_ddd_contato             in number,
					     p_nr_telefone_contato        in number,
					     p_nr_ddd_cel_terceiro        in number,
					     p_nr_tel_cel_terceiro        in number,
					     p_id_email_terceiro          in varchar2,
					     p_ds_bens                    in varchar2,
					     p_id_terceiro_re             in out number,
					     p_mens                       out varchar2) is
		v_saida_anormal exception;
	begin
		if p_id_terceiro_re is not null then
			begin
				update asw0017_terceiro_re
				   set id_tipo_pessoa_terc        = p_id_tipo_pessoa_terc,
				       nr_cpf_cnpj_terc           = p_nr_cpf_cnpj_terc,
				       nm_terceiro                = p_nm_terceiro,
				       id_cep_ocorrencia          = p_id_cep_ocorrencia,
				       ds_local_ocorrencia        = p_ds_local_ocorrencia,
				       nr_local_ocorrencia        = p_nr_local_ocorrencia,
				       nm_bairro_ocorrencia       = p_nm_bairro_ocorrencia,
				       nm_municipio_ocorrencia    = p_nm_municipio_ocorrencia,
				       id_unidade_federacao_ocorr = p_id_unidade_federacao_ocorr,
				       nr_ddd_contato             = p_nr_ddd_contato,
				       nr_telefone_contato        = p_nr_telefone_contato,
				       nr_ddd_cel_terceiro        = p_nr_ddd_cel_terceiro,
				       nr_tel_cel_terceiro        = p_nr_tel_cel_terceiro,
				       id_email_terceiro          = p_id_email_terceiro,
				       ds_bens                    = p_ds_bens
				 where id_terceiro_re = p_id_terceiro_re
				   and id_aviso_sinst_re_sgrdo =
				       p_id_aviso_sinst_re_sgrdo;
			exception
				when others then
					p_mens := 'Problemas ao tentar atualizar terceiro ' ||
						  p_id_terceiro_re ||
						  '. Erro: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
		else
			begin
				select seq_asw00017_re_terc.nextval
				  into p_id_terceiro_re
				  from dual;
			exception
				when others then
					p_mens := 'Problemas ao tentar recuperar proxima sequencia para incluso de terceito. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			--
			begin
				insert into asw0017_terceiro_re
					(id_terceiro_re, --number(38)      not     null    ,
					 id_aviso_sinst_re_sgrdo, --number(38)      not     null    ,
					 id_tipo_pessoa_terc, --varchar2(1)     not     null    ,
					 nr_cpf_cnpj_terc, --number(15)      not     null    ,
					 nm_terceiro, --varchar2(80)    not     null
					 id_cep_ocorrencia, --=       p_id_cep_ocorrencia             ,
					 ds_local_ocorrencia, --=       p_ds_local_ocorrencia           ,
					 nr_local_ocorrencia, --=       p_nr_local_ocorrencia           ,
					 nm_bairro_ocorrencia, --=       p_nm_bairro_ocorrencia          ,
					 nm_municipio_ocorrencia, --=       p_nm_municipio_ocorrencia       ,
					 id_unidade_federacao_ocorr, --=       p_id_unidade_federacao_ocorr    ,
					 nr_ddd_contato, --=       p_nr_ddd_contato                ,
					 nr_telefone_contato, --=       p_nr_telefone_contato           ,
					 nr_ddd_cel_terceiro, --=       p_nr_ddd_cel_terceiro           ,
					 nr_tel_cel_terceiro, --=       p_nr_tel_cel_terceiro           ,
					 id_email_terceiro, --=       p_id_email_terceiro             ,
					 ds_bens --=       p_ds_bens
					 )
				values
					(p_id_terceiro_re,
					 p_id_aviso_sinst_re_sgrdo,
					 p_id_tipo_pessoa_terc,
					 p_nr_cpf_cnpj_terc,
					 p_nm_terceiro,
					 p_id_cep_ocorrencia,
					 p_ds_local_ocorrencia,
					 p_nr_local_ocorrencia,
					 p_nm_bairro_ocorrencia,
					 p_nm_municipio_ocorrencia,
					 p_id_unidade_federacao_ocorr,
					 p_nr_ddd_contato,
					 p_nr_telefone_contato,
					 p_nr_ddd_cel_terceiro,
					 p_nr_tel_cel_terceiro,
					 p_id_email_terceiro,
					 p_ds_bens);
			exception
				when others then
					p_mens := 'Problemas ao tentar inserir novo registro de terceiro. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
		end if;
	exception
		when v_saida_anormal then
			p_mens := 'PRC_INCLUI_ALTERA_TERCEIRO - ' || p_mens;
			return;
		when others then
			p_mens := 'PRC_INCLUI_ALTERA_TERCEIRO - Erro Geral: ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			return;
	end;

	/***********************************************************************************
        prc_exclui_terceiros
            Author  : Paulo H. Garcia
            Created : 26/05/2012
            Purpose : Rotina responsavel por excluir terceiros do aviso de RE
        ***********************************************************************************/
	procedure prc_exclui_terceiros(p_id_aviso_sinst_re_sgrdo in number,
				       p_mens                    out varchar2) is
	begin
		delete asw0017_terceiro_re asw0017
		 where asw0017.id_aviso_sinst_re_sgrdo =
		       p_id_aviso_sinst_re_sgrdo;
	exception
		when others then
			p_mens := 'PRC_EXCLUI_TERCEIROS - Problemas ao tentar excluir terceiros vinculados ao aviso ' ||
				  p_id_aviso_sinst_re_sgrdo || '. Erro: ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			return;
	end;

	/***********************************************************************************
        prc_coberturas_apolice
            Author  : Paulo H. Garcia
            Created : 28/05/2012
            Purpose : Rotina responsavel por retornar todas as coberturas da aplice escolhida
        ***********************************************************************************/
	procedure prc_coberturas_apolice(p_id_aviso_sinst_re_sgrdo in number,
					 p_cursor                  out tab_coberturas_apolice,
					 p_mens                    out varchar2) is
		cursor c1 is
			select asw0016.cd_cia_sgdra,
			       asw0016.cd_ramo_apoli,
			       asw0016.cd_local_apoli,
			       asw0016.cd_apoli,
			       asw0016.cd_item_apoli,
			       asw0016.cd_tipo_endos,
			       asw0016.cd_endos,
			       asw0016.dt_arquv,
			       asw0016.cd_prdut
			  from asw0016_aviso_sinst_re_sgrdo asw0016
			 where asw0016.id_aviso_sinst_re_sgrdo =
			       p_id_aviso_sinst_re_sgrdo;
		--
		v_saida_anormal exception;
	begin
		for r1 in c1 loop
			if r1.cd_cia_sgdra = global_cd_cia_seguradora then
				begin
					open p_cursor for
						select a.cd_cobertura_basica,
						       '* ' ||
						       b.ds_cobertura_basica,
						       null --a.vl_importancia_segurada
						  from sin_apolice_item_cober_basica a,
						       sin_cobertura_basica          b
						 where a.cd_companhia_segur_emissao =
						       r1.cd_cia_sgdra
						   and a.cd_ramo_produto =
						       r1.cd_ramo_apoli
						   and a.cd_apolice =
						       r1.cd_apoli
						   and a.cd_tipo_endosso =
						       r1.cd_tipo_endos
						   and a.cd_endosso =
						       r1.cd_endos
						   and a.cd_item_apolice =
						       r1.cd_item_apoli
						   and a.cd_produto =
						       r1.cd_prdut
						   and a.cd_tipo_bem_segurado =
						       b.cd_tipo_bem_segurado
						   and a.cd_caracteristica_bem_segur =
						       b.cd_caracteristica_bem_segur
						   and a.cd_cobertura_basica =
						       b.cd_cobertura_basica
						union
						select c.cd_cobertura_adicional,
						       '* ' ||
						       d.ds_cobertura_adicional,
						       null --c.vl_importancia_segurada
						  from sin_apolice_item_cober_adici c,
						       sin_cobertura_adicional      d
						 where c.cd_companhia_segur_emissao =
						       r1.cd_cia_sgdra
						   and c.cd_ramo_produto =
						       r1.cd_ramo_apoli
						   and c.cd_apolice =
						       r1.cd_apoli
						   and c.cd_tipo_endosso =
						       r1.cd_tipo_endos
						   and c.cd_endosso =
						       r1.cd_endos
						   and c.cd_item_apolice =
						       r1.cd_item_apoli
						   and c.cd_produto =
						       r1.cd_prdut
						   and c.cd_tipo_bem_segurado =
						       d.cd_tipo_bem_segurado
						   and c.cd_caracteristica_bem_segur =
						       d.cd_caracteristica_bem_segur
						   and c.cd_cobertura_adicional =
						       d.cd_cobertura_adicional;
				exception
					when others then
						p_mens := 'TMS - Problemas ao tentar recuperar coberturas da aplice. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				--
			else
				p_mens := 'Companhia ' || r1.cd_cia_sgdra ||
					  ' inválida.';
				raise v_saida_anormal;
			end if;
		end loop;
	exception
		when v_saida_anormal then
			p_mens := 'PRC_COBERTURAS_APOLICE - ' || p_mens;
			open p_cursor for
				select null, null, null from dual;
			return;
		when others then
			p_mens := 'PRC_COBERTURAS_APOLICE - Erro geral: ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			open p_cursor for
				select null, null, null from dual;
			return;
	end;
	--
	/******************************************************************************
        Autor: Joao Cesario / Data.: 21/03/2022
        Desc: Retorna os campos novos inclusos no projeto de Alteração de Naturezas,
	similar ao prc_resumo_aviso
        *******************************************************************************/
	--
	procedure prc_resumo_aviso_veiculo(P_CD_RECLAMACAO_ELEMENTAR in out number,
					P_ID_NECESSIDADE_VISTORIA       out varchar2,
					P_CD_TIPO_VISTORIA_SINISTRO     out number,
					P_NM_TIPO_VISTORIA_SINISTRO     out varchar2,
					P_CD_VISTORIADOR_SINISTRO       out number,
					P_NM_VISTORIADOR_SINISTRO	out varchar2,
					P_ID_NECESSIDADE_PERITO     	out varchar2,
					P_CD_PERITO_SINISTRO        	out number,
					P_NM_PERITO_SINISTRO		out varchar2,
					P_ID_PLACA_TRANSPORTADOR        out varchar2,
					P_VL_EMBARQUE       		out number,
					P_DT_CTRC       		out date,
					P_DS_ORIGEM    	 		out varchar2,
					P_DS_DESTINO        		out varchar2,
					P_TAB_ASW24			out tab_asw24,
					P_MENS				out varchar2) is
		v_saida_anormal exception;
		--
		cursor	c0	is
		select	*
		from	sinistro_reclamacao_eleme	a
		where	a.cd_reclamacao_elementar	=	p_cd_reclamacao_elementar;
		--
		cursor	c1	is
		select	*
		from	ASW0024_AVISO_SINST_RE_VEIC	a
		where	a.cd_reclamacao_elementar	=	p_cd_reclamacao_elementar;
		--
		cursor c2	is
		select	*
		from	sinistro_info_complementar	a
		where	a.cd_reclamacao_elementar	=	p_cd_reclamacao_elementar;
		--
		cursor c3	is
		select	*
		from	sinistro_vistoria_eleme	a
		where	a.cd_reclamacao_elementar	=	p_cd_reclamacao_elementar;
	begin
		if p_cd_reclamacao_elementar is null then
			p_mens := 'Não foi recebido o numero do aviso.';
			raise v_saida_anormal;
		end if;

		for	r0	in	c0	loop
			P_ID_NECESSIDADE_VISTORIA       := r0.ID_NECESSIDADE_VISTORIA;
			P_CD_VISTORIADOR_SINISTRO       := r0.CD_VISTORIADOR_SINISTRO;
			P_ID_NECESSIDADE_PERITO     	:= r0.ID_NECESSIDADE_PERITO;
			P_CD_PERITO_SINISTRO        	:= r0.CD_PERITO_SINISTRO;
			begin
				select nm_vistoriador
				into P_NM_VISTORIADOR_SINISTRO
				from sinistro_vistoriador sv
				where sv.cd_vistoriador_sinistro = r0.CD_VISTORIADOR_SINISTRO;
			exception
				when no_data_found then
					null;
				when others then
					p_mens := 'Falha ao recuperar nome do Vistoriador. Codigo: ' || P_CD_VISTORIADOR_SINISTRO;
					raise v_saida_anormal;
			end;
			----
			begin
				select nm_perito
				into P_NM_PERITO_SINISTRO
				from sinistro_perito sp
				where sp.cd_perito_sinistro = r0.CD_PERITO_SINISTRO;
			exception
				when no_data_found then
					null;
				when others then
					p_mens := 'Falha ao recuperar nome do Perito. Codigo: ' || P_CD_PERITO_SINISTRO;
					raise v_saida_anormal;
			end;

		end loop;
		--
		for	r2	in	c2	loop
			P_ID_PLACA_TRANSPORTADOR        := r2.ID_PLACA;
			P_VL_EMBARQUE       		:= r2.VL_EMBARQUE;
			P_DT_CTRC       		:= r2.DT_CTRC;
			P_DS_ORIGEM    	 		:= r2.DS_ORIGEM;
			P_DS_DESTINO        		:= r2.DS_DESTINO;


		end loop;
		--
		begin
			open P_TAB_ASW24 for
				select
					a.cd_fabricante,
					a.cd_modelo_veiculo,
					a.cd_combustivel,
					a.cd_veiculo,
					a.cd_ano_veiculo,
					a.id_placa
				from
					ASW0024_AVISO_SINST_RE_VEIC a
				where	a.cd_reclamacao_elementar	=	p_cd_reclamacao_elementar;
		exception
			when no_data_found then
				null;
			when others then
				p_mens := 'Falha ao recuperar dados dos veículos envolvidos. Aviso: ' || p_cd_reclamacao_elementar;
				raise v_saida_anormal;
		end;
		--
		for	r3	in	c3	loop
			P_CD_TIPO_VISTORIA_SINISTRO     := r3.CD_TIPO_VISTORIA_SINISTRO;

			begin
				select ds_tipo_vistoria
				into P_NM_TIPO_VISTORIA_SINISTRO
				from sinistro_tipo_vistoria stv
				where stv.cd_tipo_vistoria_sinistro = P_CD_TIPO_VISTORIA_SINISTRO;
			exception
				when no_data_found then
					null;
				when others then
					p_mens := 'Falha ao recuperar nome do Tipo de Vistoria. Codigo: ' || P_CD_TIPO_VISTORIA_SINISTRO;
					raise v_saida_anormal;
			end;

		end loop;

	exception
		when v_saida_anormal then
	               p_mens := 'prc_resumo_aviso_veiculo - ' || p_mens;
		when others then
	               p_mens := 'prc_resumo_aviso_veiculo - Erro geral: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	end;

	/***********************************************************************************
        prc_resumo_aviso
            Author  : Paulo H. Garcia
            Created : 05/06/2012
            Purpose : Procedure que retorna dados do aviso para o resumo.
            ***********************************************************************************/
	procedure prc_resumo_aviso(p_cd_reclamacao_elementar in out number,
				   p_nm_comunicante          out varchar2,
				   p_nr_ddd_com_comunicante  out number,
				   p_nr_tel_com_comunicante  out number,
				   p_nr_ddd_cel_comunicante  out number,
				   p_nr_tel_cel_comunicante  out number,
				   p_ds_email_comunicante    out varchar2,
				   p_nm_contato              out varchar2,
				   p_ds_forma_contato        out varchar2,
				   p_nr_ddd_com_contato      out number,
				   p_nr_tel_com_contato      out number,
				   p_nr_ddd_cel_contato      out number,
				   p_nr_tel_cel_contato      out number,
				   p_ds_email_contato        out varchar2,
				   p_nr_bo                   out varchar2,
				   p_nr_delegacia            out varchar2,
				   p_nr_cep_ocorrencia       out number,
				   p_ds_endereco_ocorrencia  out varchar2,
				   p_nr_endereco_ocorrencia  out varchar2,
				   p_ds_bairro_ocorrencia    out varchar2,
				   p_ds_cidade_ocorrencia    out varchar2,
				   p_ds_uf_ocorrencia        out varchar2,
				   p_ds_complemento          out varchar2,
				   p_ds_ocorrencia           out varchar2,
				   p_ds_tipo_ocorrencia      out varchar2,
				   p_ds_cobertura            out varchar2,
				   p_vl_estimativa_prejuizo  out varchar2,
				   p_ds_bens_danificados     out varchar2,
				   p_ds_observacoes          out varchar2,
				   p_ds_necessidade_vistoria out varchar2,
				   p_nm_vistoriador          out varchar2,
				   p_nm_transportadora       out varchar2,
				   p_nr_nota_fiscal          out varchar2,
				   p_id_chassi               out varchar2,
				   p_id_ctrc                 out varchar2,
				   p_ds_bem_segurado         out varchar2,
				   p_id_matricula            out varchar2, --Endesa
				   p_cursor_terceiro         out tab_terceiro_re,
				   p_mens                    out varchar2) is
		--
		v_saida_anormal exception;
		v_id_forma_contato            number := null;
		v_cd_cobertura_basica         number := null;
		v_cd_cobertura_adicional      number := null;
		v_cd_cobertura_especial       number := null;
		v_cd_cober_espec_espec        number := null;
		v_cd_tipo_bem_segurado        number := null;
		v_cd_caracteristica_bem_segur number := null;
		v_cd_ramo                     number := null;
		v_cd_apolice                  number := null;
		v_cd_vistoriador_sinistro     number := null;
		v_vl_estimativa_prejuizo      number := null;
		--
		cursor	c0	is
		select	*
		from	asw0016_aviso_sinst_re_sgrdo	a
		where	a.nr_aviso	=	p_cd_reclamacao_elementar;
		--
		v_liga				varchar2(1);
		--
	begin
		if p_cd_reclamacao_elementar is null then
			p_mens := 'Não foi recebido o numero do aviso.';
			raise v_saida_anormal;
		end if;
		begin
			--
			select	a.vl_char
			into	v_liga
			from	politicas_parametro	a
			where	a.nm_politica_parametro	=	'LIGA_7070_008_BATCH_AVISO';
			--
		exception
			when	others	then
				--
				v_liga	:=	'N';
				--
		end;
			--
		if	v_liga	=	'S'	then
			--
			for	r0	in	c0	loop
				--
				p_nm_comunicante		:=	r0.nm_comnt;
				p_nr_ddd_com_comunicante	:=	r0.nr_ddd_telef_comrl_comnt;
				p_nr_tel_com_comunicante	:=	r0.nr_telef_comrl_comnt;
				p_nr_ddd_cel_comunicante	:=	r0.nr_ddd_celul_comnt;
				p_nr_tel_cel_comunicante	:=	r0.nr_telef_celul_comnt;
				p_ds_email_comunicante		:=	r0.cd_email_comnt;
				p_nm_contato			:=	r0.nm_contt;
				--
				begin
					select	upper(a.rv_meaning)
					into	p_ds_forma_contato
					from	automovel_ref_codes	a
					where	a.rv_domain	=	'SINISTRO CONTATO'
					and	a.rv_low_value	=	r0.cd_forma_contt;
				exception
					when others then
						p_ds_forma_contato := null;
				end;
				--
				p_nr_ddd_com_contato		:=	r0.nr_ddd_comrl_contt;
				p_nr_tel_com_contato		:=	r0.nr_telef_comrl_contt;
				p_nr_ddd_cel_contato		:=	r0.nr_ddd_celul_contt;
				p_nr_tel_cel_contato		:=	r0.nr_telef_celul_contt;
				p_ds_email_contato		:=	r0.cd_email_contt;
				p_nr_bo				:=	r0.cd_num_bo;
				p_nr_delegacia			:=	r0.id_deleg_bo;
				p_nr_cep_ocorrencia		:=	r0.id_cep_local_sinis;
				p_ds_endereco_ocorrencia	:=	r0.nm_logra_loc_sinis;
				p_nr_endereco_ocorrencia	:=	r0.nr_logra_loc_sinis;
				p_ds_bairro_ocorrencia		:=	r0.nm_bairro_loc_sinis;
				p_ds_cidade_ocorrencia		:=	r0.nm_cidad_loc_sinis;
				p_ds_uf_ocorrencia		:=	r0.sg_unidd_fedrc_loc_sinis;
				p_ds_complemento		:=	r0.ds_complemento_loc_sinis;
				p_ds_ocorrencia			:=	r0.ds_descr_sinis;
				--
				begin
					select	sn.ds_natureza_sinistro
					into	p_ds_tipo_ocorrencia
					from	sinistro_natureza	sn
					where	sn.cd_natureza_sinistro	=	r0.id_tipo_ocorr_sinis;
				exception
					when others then
						p_ds_tipo_ocorrencia := null;
				end;
				--
				if	r0.cd_cobertura_adicional	is	not	null	then
					--
					begin
					select	ca.ds_cobertura_adicional
					into	p_ds_cobertura
					from	sin_cobertura_adicional		ca
					where	ca.cd_tipo_bem_segurado		=	r0.cd_tipo_bem_segrdo
					and	ca.cd_caracteristica_bem_segur	=	r0.cd_carac_bem_segrdo
					and	ca.cd_ramo			=	r0.cd_ramo_cobertura
					and	ca.cd_cobertura_adicional	=	r0.cd_cobertura_adicional;
					exception
						when	others	then
							--
							p_ds_cobertura	:=	null;
							--
					end;
					--
				elsif	r0.cd_cobertura_basica	is	not	null	then
					--
					begin
					select	cb.ds_cobertura_basica
					into	p_ds_cobertura
					from	sin_cobertura_basica		cb
					where	cb.cd_tipo_bem_segurado		=	r0.cd_tipo_bem_segrdo
					and	cb.cd_caracteristica_bem_segur	=	r0.cd_carac_bem_segrdo
					and	cb.cd_ramo			=	r0.cd_ramo_cobertura
					and	cb.cd_cobertura_basica		=	r0.cd_cobertura_basica;
					exception
						when	others	then
							--
							p_ds_cobertura := null;
							--
					end;
					--
				else
					--
					p_ds_cobertura := null;
					--
				end	if;
				--
				--recupera faixa de valor
				begin
					select 'De R$' || replace(to_char(scfw.vl_inicial,'999g999g990d00'),' ','') || '  R$' ||replace(to_char(scfw.vl_final,'999g999g990d00'),' ','')
				into	p_vl_estimativa_prejuizo
				from	sinistro_controle_faixa_web		scfw
				where	scfw.vl_adotado 			=	r0.vl_estimativa_prejuizo
				and	scfw.cd_tipo_bem_segurado		=	r0.cd_tipo_bem_segrdo
				and	scfw.cd_caracteristica_bem_segur	=	r0.cd_carac_bem_segrdo
				and	scfw.cd_ramo				=	r0.cd_cobertura_basica;
				exception
					when	others	then
						--
						p_vl_estimativa_prejuizo	:=	'R$' ||r0.vl_estimativa_prejuizo;
						--
				end;
				--
				p_ds_bens_danificados		:=	r0.cd_bens_dani_sinis;
				p_ds_observacoes		:=	r0.cd_observ_sinis;
				p_ds_necessidade_vistoria	:=	'N';
				p_nm_vistoriador		:=	null;
				p_nm_transportadora		:=	null;
				p_nr_nota_fiscal		:=	null;
				p_id_chassi			:=	null;
				p_id_ctrc			:=	null;
				p_ds_bem_segurado		:=	null;
				p_id_matricula			:=	null;
				--
			end	loop;
			--
			--carrega terceiros
			begin
				open	p_cursor_terceiro	for
					--
					select	id_terceiro_re,
						id_tipo_pessoa_terc,
						st.nr_cpf_cnpj_terc,
						nm_terceiro,
						id_cep_ocorrencia,
						ds_local_ocorrencia,
						nr_local_ocorrencia,
						nm_bairro_ocorrencia,
						nm_municipio_ocorrencia,
						id_unidade_federacao_ocorr,
						nr_ddd_contato,
						nr_telefone_contato,
						nr_ddd_cel_terceiro,
						nr_tel_cel_terceiro,
						id_email_terceiro,
						ds_bens
					from	asw0017_terceiro_re	st
					where	st.id_aviso_sinst_re_sgrdo	=	p_cd_reclamacao_elementar;
			exception
				when	others	then
					--
					p_mens	:=	'Problemas ao tentar carregar lista de terceiros do aviso ' ||p_cd_reclamacao_elementar ||'. Erro: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise	v_saida_anormal;
					--
			end;
			--
		else--*/
			--
			begin
				select sre.nm_informante_reclamacao,
				       sre.nr_ddd_informante,
				       sre.nr_telefone_informante,
				       sre.nr_ddd_celular_informante,
				       sre.nr_celular_informante,
				       sre.id_email_informante,
				       sre.nm_contato_vistoria,
				       sre.id_forma_contato,
				       sre.nr_ddd_contato,
				       sre.nr_telefone_contato,
				       sre.nr_ddd_cel_contato,
				       sre.nr_tel_cel_contato,
				       sre.id_email_contato,
				       sre.nr_bo,
				       sre.nr_delegacia,
				       sre.id_cep_local_vistoria,
				       sre.ds_endereco_vistoria,
				       sre.nr_endereco_vistoria,
				       sre.nm_bairro_vistoria,
				       sre.nm_municipio_vistoria,
				       sre.id_unidade_federacao_vistor,
				       sre.ds_ocorrencia,
				       sre.ds_natureza_sinistro,
				       sre.ds_bens,
				       sre.ds_observacao,
				       decode(sre.id_necessidade_vistoria,
					      'S',
					      'SIM',
					      'NO'),
				       sre.nm_empresa_transportadora,
				       sre.id_nota_fiscal,
				       sre.id_chassi,
				       sre.vl_estimativa_web,
				       sre.id_ctrc,
				       sre.cd_cobertura_basica,
				       sre.cd_cobertura_adicional,
				       sre.cd_cobertura_especial,
				       sre.cd_cober_espec_espec,
				       sre.cd_tipo_bem_segurado,
				       sre.cd_caracteristica_bem_segur,
				       sre.cd_ramo,
				       sre.cd_apolice,
				       sre.cd_vistoriador_sinistro,
				       sre.nm_complemento_ender_vistor,
				       sre.id_matricula
				  into p_nm_comunicante,
				       p_nr_ddd_com_comunicante,
				       p_nr_tel_com_comunicante,
				       p_nr_ddd_cel_comunicante,
				       p_nr_tel_cel_comunicante,
				       p_ds_email_comunicante,
				       p_nm_contato,
				       v_id_forma_contato,
				       p_nr_ddd_com_contato,
				       p_nr_tel_com_contato,
				       p_nr_ddd_cel_contato,
				       p_nr_tel_cel_contato,
				       p_ds_email_contato,
				       p_nr_bo,
				       p_nr_delegacia,
				       p_nr_cep_ocorrencia,
				       p_ds_endereco_ocorrencia,
				       p_nr_endereco_ocorrencia,
				       p_ds_bairro_ocorrencia,
				       p_ds_cidade_ocorrencia,
				       p_ds_uf_ocorrencia,
				       p_ds_ocorrencia,
				       p_ds_tipo_ocorrencia,
				       p_ds_bens_danificados,
				       p_ds_observacoes,
				       p_ds_necessidade_vistoria,
				       p_nm_transportadora,
				       p_nr_nota_fiscal,
				       p_id_chassi,
				       v_vl_estimativa_prejuizo,
				       p_id_ctrc,
				       v_cd_cobertura_basica,
				       v_cd_cobertura_adicional,
				       v_cd_cobertura_especial,
				       v_cd_cober_espec_espec,
				       v_cd_tipo_bem_segurado,
				       v_cd_caracteristica_bem_segur,
				       v_cd_ramo,
				       v_cd_apolice,
				       v_cd_vistoriador_sinistro,
				       p_ds_complemento,
				       p_id_matricula
				  from sinistro_reclamacao_eleme sre
				 where sre.cd_reclamacao_elementar =
				       p_cd_reclamacao_elementar;
			exception
				when no_data_found then
					p_mens := 'Aviso ' ||
						  p_cd_reclamacao_elementar ||
						  ' não localizado.';
					raise v_saida_anormal;
				when others then
					p_mens := 'Problemas ao tentar recuperar informaes do aviso ' ||
						  p_cd_reclamacao_elementar ||
						  '. Erro: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			--
			begin
				select upper(a.rv_meaning)
				  into p_ds_forma_contato
				  from automovel_ref_codes a
				 where a.rv_domain = 'SINISTRO CONTATO'
				   and a.rv_low_value = v_id_forma_contato;
			exception
				when others then
					p_ds_forma_contato := null;
			end;
			--
			if v_cd_cober_espec_espec is not null or
			   v_cd_cobertura_especial is not null then
				begin
					select ce.ds_cobertura_especial
					  into p_ds_cobertura
					  from cobertura_especial ce
					 where ce.cd_tipo_bem_segurado =
					       v_cd_tipo_bem_segurado
					   and ce.cd_caracteristica_bem_segur =
					       v_cd_caracteristica_bem_segur
					   and ce.cd_ramo = v_cd_ramo
					   and ce.cd_cobertura_especial =
					       v_cd_cober_espec_espec;
				exception
					when others then
						p_ds_cobertura := null;
				end;
			elsif v_cd_cobertura_adicional is not null then
				if v_cd_apolice is not null then
					begin
						select ca.ds_cobertura_adicional
						  into p_ds_cobertura
						  from cobertura_adicional ca
						 where ca.cd_tipo_bem_segurado =
						       v_cd_tipo_bem_segurado
						   and ca.cd_caracteristica_bem_segur =
						       v_cd_caracteristica_bem_segur
						   and ca.cd_ramo = v_cd_ramo
						   and ca.cd_cobertura_adicional =
						       v_cd_cobertura_adicional;
					exception
						when others then
							p_ds_cobertura := null;
					end;
				else
					begin
						select ca.ds_cobertura_adicional
						  into p_ds_cobertura
						  from sin_cobertura_adicional ca
						 where ca.cd_tipo_bem_segurado =
						       v_cd_tipo_bem_segurado
						   and ca.cd_caracteristica_bem_segur =
						       v_cd_caracteristica_bem_segur
						   and ca.cd_ramo = v_cd_ramo
						   and ca.cd_cobertura_adicional =
						       v_cd_cobertura_adicional;
					exception
						when others then
							p_ds_cobertura := null;
					end;
				end if;
			elsif v_cd_cobertura_basica is not null then
				if v_cd_apolice is not null then
					begin
						select cb.ds_cobertura_basica
						  into p_ds_cobertura
						  from cobertura_basica cb
						 where cb.cd_tipo_bem_segurado =
						       v_cd_tipo_bem_segurado
						   and cb.cd_caracteristica_bem_segur =
						       v_cd_caracteristica_bem_segur
						   and cb.cd_ramo = v_cd_ramo
						   and cb.cd_cobertura_basica =
						       v_cd_cobertura_basica;
					exception
						when others then
							p_ds_cobertura := null;
					end;
				else
					begin
						select cb.ds_cobertura_basica
						  into p_ds_cobertura
						  from sin_cobertura_basica cb
						 where cb.cd_tipo_bem_segurado =
						       v_cd_tipo_bem_segurado
						   and cb.cd_caracteristica_bem_segur =
						       v_cd_caracteristica_bem_segur
						   and cb.cd_ramo = v_cd_ramo
						   and cb.cd_cobertura_basica =
						       v_cd_cobertura_basica;
					exception
						when others then
							p_ds_cobertura := null;
					end;
				end if;
			else
				p_ds_cobertura := null;
			end if;
			--
			if v_cd_vistoriador_sinistro is not null then
				begin
					select sv.nm_vistoriador
					  into p_nm_vistoriador
					  from sinistro_vistoriador sv
					 where sv.cd_vistoriador_sinistro =
					       v_cd_vistoriador_sinistro;
				exception
					when others then
						p_nm_vistoriador := null;
				end;
			end if;
			if p_mens is not null then
				raise v_saida_anormal;
			end if;
			--recupera faixa de valor
			begin
				select 'De R$' || replace(to_char(scfw.vl_inicial,
								  '999g999g990d00'),
							  ' ',
							  '') || '  R$' ||
				       replace(to_char(scfw.vl_final,
						       '999g999g990d00'),
					       ' ',
					       '')
				  into p_vl_estimativa_prejuizo
				  from sinistro_controle_faixa_web scfw
				 where scfw.vl_adotado = v_vl_estimativa_prejuizo
				   and scfw.cd_tipo_bem_segurado =
				       v_cd_tipo_bem_segurado
				   and scfw.cd_caracteristica_bem_segur =
				       v_cd_caracteristica_bem_segur
				   and scfw.cd_ramo = v_cd_ramo;
			exception
				when others then
					p_vl_estimativa_prejuizo := 'R$' ||
								    v_vl_estimativa_prejuizo;
			end;
			--
			--carrega terceiros
			begin
				open p_cursor_terceiro for
					select st.cd_terceiro_sinistro,
					       st.id_tipo_terceiro,
					       decode(st.id_tipo_terceiro,
						      'F',
						      (lpad(st.nr_cnpj_cpf_terceiro,
							    9,
							    0) ||
						      lpad(st.nr_digito_verificador,
							    2,
							    0)),
						      'J',
						      (lpad(st.nr_cnpj_cpf_terceiro,
							    8,
							    0) ||
						      lpad(st.nr_estabelecimento_terceiro,
							    4,
							    0) ||
						      lpad(st.nr_digito_verificador,
							    2,
							    0))),
					       st.nm_terceiro,
					       sret.id_cep_ocorrencia,
					       sret.ds_local_ocorrencia,
					       sret.nr_local_ocorrencia,
					       sret.nm_bairro_ocorrencia,
					       sret.nm_municipio_ocorrencia,
					       sret.id_unidade_federacao_ocorr,
					       st.nr_ddd_residencial,
					       st.nr_telefone_residencial,
					       st.nr_ddd_celular,
					       st.nr_celular,
					       sret.id_email_terceiro,
					       sret.ds_bens
					  from sinistro_terceiro            st,
					       sinis_reclamacao_eleme_terce sret
					 where sret.cd_reclamacao_elementar =
					       p_cd_reclamacao_elementar
					   and sret.cd_terceiro_sinistro =
					       st.cd_terceiro_sinistro;
			exception
				when others then
					p_mens := 'Problemas ao tentar carregar lista de terceiros do aviso ' ||
						  p_cd_reclamacao_elementar ||
						  '. Erro: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			--
		end	if;
		--
	exception
		when v_saida_anormal then
			p_mens := 'PRC_RESUMO_AVISO - ' || p_mens;
			open p_cursor_terceiro for
				select null, --st.cd_terceiro_sinistro,
				       null, --st.id_tipo_terceiro,
				       null, --decode(st.id_tipo_terceiro,'F',(lpad(st.nr_cnpj_cpf_terceiro,9,0)||'-'||lpad(st.nr_digito_verificador,2,0)),'J',(lpad(st.nr_cnpj_cpf_terceiro,8,0)||lpad(st.nr_estabelecimento_terceiro ,4,0)||'-'||lpad(st.nr_digito_verificador,2,0)),
				       null, --st.nm_terceiro,
				       null, --sret.id_cep_ocorrencia,
				       null, --sret.ds_local_ocorrencia,
				       null, --sret.nr_local_ocorrencia,
				       null, --sret.nm_bairro_ocorrencia,
				       null, --sret.nm_municipio_ocorrencia,
				       null, --sret.id_unidade_federacao_ocorr,
				       null, --st.nr_ddd_contato,
				       null, --st.nr_telefone_contato,
				       null, --st.nr_ddd_cel_terceiro,
				       null, --st.nr_tel_cel_terceiro,
				       null, --st.id_mail,
				       null --sret.ds_bens
				  from dual;
			return;
		when others then
			p_mens := 'PRC_RESUMO_AVISO - Erro geral: ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			open p_cursor_terceiro for
				select null, --st.cd_terceiro_sinistro,
				       null, --st.id_tipo_terceiro,
				       null, --decode(st.id_tipo_terceiro,'F',(lpad(st.nr_cnpj_cpf_terceiro,9,0)||'-'||lpad(st.nr_digito_verificador,2,0)),'J',(lpad(st.nr_cnpj_cpf_terceiro,8,0)||lpad(st.nr_estabelecimento_terceiro ,4,0)||'-'||lpad(st.nr_digito_verificador,2,0)),
				       null, --st.nm_terceiro,
				       null, --sret.id_cep_ocorrencia,
				       null, --sret.ds_local_ocorrencia,
				       null, --sret.nr_local_ocorrencia,
				       null, --sret.nm_bairro_ocorrencia,
				       null, --sret.nm_municipio_ocorrencia,
				       null, --sret.id_unidade_federacao_ocorr,
				       null, --st.nr_ddd_contato,
				       null, --st.nr_telefone_contato,
				       null, --st.nr_ddd_cel_terceiro,
				       null, --st.nr_tel_cel_terceiro,
				       null, --st.id_mail,
				       null --sret.ds_bens
				  from dual;
			return;
	end;

	/***********************************************************************************
        prc_faixa_estimativa
            Author  : Paulo H. Garcia
            Created : 20/06/2012
            Purpose : Proc que monta lista de faixas de estimativa
            ***********************************************************************************/
	procedure prc_faixa_estimativa(p_cd_tipo_bem_segurado  in number,
				       p_cd_carac_bem_segurado in number,
				       p_cd_ramo               in number,
				       p_cursor                out tab_prc_faixa_estimativa,
				       p_mens                  out varchar2) is
	begin
		open p_cursor for
			select 'De R$' || replace(to_char(scfw.vl_inicial,
							  '999g999g990d00'),
						  ' ',
						  '') || '  R$' ||
			       replace(to_char(scfw.vl_final,
					       '999g999g990d00'),
				       ' ',
				       ''),
			       scfw.id_sinistro_controle
			  from sinistro_controle_faixa_web scfw
			 where scfw.cd_tipo_bem_segurado =
			       p_cd_tipo_bem_segurado
			   and scfw.cd_caracteristica_bem_segur =
			       p_cd_carac_bem_segurado
			   and scfw.cd_ramo = p_cd_ramo
			 order by scfw.vl_inicial;
	exception
		when others then
			p_mens := 'Problemas ao tentar recuperar faixa de valores para o ramo ' ||
				  p_cd_tipo_bem_segurado || ' - ' ||
				  p_cd_carac_bem_segurado || ' - ' ||
				  p_cd_ramo || '. Erro: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			open p_cursor for
				select null, null from dual;
	end;

	/***********************************************************************************
        prc_faixa_estimativa_portal
        Author      : Guilherme Vilela
        Creater       : 04/12/2017
        Purpose       : Atender demanda do portal afinidades para faixa de estimativas
        **********************************************************************************/
	procedure prc_faixa_estimativa_portal(p_cd_tipo_bem_segurado  in number,
					      p_cd_carac_bem_segurado in number,
					      p_cd_ramo               in number,
					      p_cursor                out tab_prc_faixa_estimativa,
					      p_mens                  out varchar2) is
		v_msg_acima varchar2(2000);
		v_msg_faixa varchar2(2000);
		v_ind       number := 1;
		v_count     number := 0;
		v_saida_anormal exception;
		v_faixa    tab_faixa_estimativa;
		v_ds_faixa varchar2(2000);
		cursor c1 is
			select scfw.vl_inicial           vl_inicial,
			       scfw.vl_final             vl_final,
			       scfw.id_sinistro_controle id_faixa
			  from sinistro_controle_faixa_web scfw
			 where scfw.cd_tipo_bem_segurado =
			       p_cd_tipo_bem_segurado
			   and scfw.cd_caracteristica_bem_segur =
			       p_cd_carac_bem_segurado
			   and scfw.cd_ramo = p_cd_ramo
			 order by scfw.vl_inicial;
	begin
		v_faixa := new tab_faixa_estimativa();
		for x in c1 loop
			v_faixa.extend(1);
			v_faixa(v_ind).vl_inicial := x.vl_inicial;
			v_faixa(v_ind).vl_final := x.vl_final;
			v_faixa(v_ind).id_faixa := x.id_faixa;
			v_ind := v_ind + 1;
		end loop;
		-- Busca mensagem padrao
		begin
			select arc.rv_low_value, arc.rv_high_value
			  into v_msg_acima, v_msg_faixa
			  from automovel_ref_codes arc
			 where arc.rv_domain = 'MENSAGEM_ACIMA_PORTALAFIN';
		exception
			when others then
				p_mens := 'SINI7070_008 - Erro ao buscar mensagem padrao - ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
		if v_faixa.count > 0 then
			for x in v_faixa.first .. v_faixa.last loop
				v_count    := v_count + 1;
				v_ds_faixa := '';
				if v_count = v_faixa.count then
					v_ds_faixa := v_msg_acima;
					v_ds_faixa := replace(v_ds_faixa,
							      '#1',
							      replace(to_char(v_faixa(x)
									      .vl_inicial,
									      '999g999g990d00'),
								      ' ',
								      ''));
				else
					v_ds_faixa := v_msg_faixa;
					v_ds_faixa := replace(v_ds_faixa,
							      '#1',
							      replace(to_char(v_faixa(x)
									      .vl_inicial,
									      '999g999g990d00'),
								      ' ',
								      ''));
					v_ds_faixa := replace(v_ds_faixa,
							      '#2',
							      replace(to_char(v_faixa(x)
									      .vl_final,
									      '999g999g990d00'),
								      ' ',
								      ''));
				end if;
				begin
					insert into temp_faixa_combos
						(id_faixa, ds_faixa)
					values
						(v_faixa(x).id_faixa,
						 v_ds_faixa);
				end;
			end loop;
		end if;
		begin
			open p_cursor for
				select ds_faixa, id_faixa
				  from temp_faixa_combos;
		end;
		commit;
	exception
		when v_saida_anormal then
			return;
		when others then
			p_mens := 'SINI7070_008.prc_faixa_estimativa_portal - Erro geral - ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	end prc_faixa_estimativa_portal;

	/***********************************************************************************
        fnc_valida_abertura
            Author  : Michael Dossa
            Created : 20/06/2012
            urpose : Função para validar abertura
            ***********************************************************************************/
	function fnc_valida_abertura(p_cd_tipo_bem_segurado        in number,
				     p_cd_caracteristica_bem_segur in number,
				     p_cd_ramo                     in number,
				     p_id_perfil_usuario           in varchar2)
		return varchar2 is
		v_count number;
		v_sql   varchar2(10000);
	begin
		v_sql := 'select count(1) from sinistro_liberacao_ramo_web where    cd_tipo_bem_segurado =' ||
			 p_cd_tipo_bem_segurado ||
			 ' and cd_caracteristica_bem_segur =' ||
			 p_cd_caracteristica_bem_segur || ' and cd_ramo = ' ||
			 p_cd_ramo || ' and ';
		if upper(p_id_perfil_usuario) = 'I' then
			v_sql := v_sql ||
				 'id_abert_autom_interno = ''S'' and id_abert_autom_callcenter = id_abert_autom_callcenter and id_abert_autom_externo = id_abert_autom_externo';
		elsif upper(p_id_perfil_usuario) = 'C' then
			v_sql := v_sql ||
				 'id_abert_autom_interno = id_abert_autom_interno and id_abert_autom_callcenter = ''S'' and id_abert_autom_externo = id_abert_autom_externo';
		elsif upper(p_id_perfil_usuario) = 'E' then
			v_sql := v_sql ||
				 'id_abert_autom_interno = id_abert_autom_interno and id_abert_autom_callcenter = id_abert_autom_callcenter and id_abert_autom_externo = ''S''';
		else
			return('N');
		end if;
		execute immediate v_sql
			into v_count;
		if v_count = 0 then
			return('N');
		else
			return('S');
		end if;
	end;

	/***********************************************************************************
        prc_busca_apolice_re_ii
            Author  : Paulo Henrique Garcia
            Created : 24/07/2012
            Purpose : Proc que localiza aplices sem validar item.
            ***********************************************************************************/
	procedure prc_busca_apolice_re_ii(p_dt_ocorrencia        in date,
					  p_id_tipo_pessoa_segur in varchar2,
					  p_nr_cpf_cnpj_segur    in number,
					  p_nr_cpf_cnpj_corre    in number,
					  p_id_cliente           in varchar2, --Endesa
					  p_id_matricula         in varchar2, --Endesa
					  --
					  p_cd_certificado in number default null, -- OS 785333
					  p_cd_bilhete     in number default null, -- OS 785333
					  --
					  p_cursor           out tab_busca_apolice_re_ii,
					  p_inicio_busca_tmb out varchar2,
					  p_fim_busca_tmb    out varchar2,
					  p_inicio_busca_tms out varchar2,
					  p_fim_busca_tms    out varchar2,
					  p_mens             out varchar2,
					  p_retorna_item	in	varchar2 default null,
					  p_cd_sessao	in	varchar2 default null) is
		v_saida_anormal exception;
		v_nr_cpf_cnpj_segur_char      varchar2(14) := null;
		v_nr_cpf_cnpj_segurado        number := null;
		v_nr_estabelecimento_segurado number := null;
		v_nr_digito_verif_segurado    number := null;
		v_busca_apolice               varchar2(1000) := null;
		v_sessao_aws                  varchar2(100) := null;
		v_id_tipo_corretor            varchar2(1) := null;
		v_ds_produto                  varchar2(100) := null;
		v_existe_apolice              number := 0;
		v_id_unifica_cias             varchar2(1);
		i                             number := 0;
		t_item                        sini7910_001.tab_item;
		v_id_endesa                   varchar2(1) := null;
		v_existe                      number;
		v_ds_item			varchar2(200) := null;
		--
		cursor c2(p_id_tipo_pessoa             varchar2,
			  p_v_nr_cnpj_segurado         number,
			  p_v_nr_estabelecimento_segur number,
			  p_v_nr_digito_verif_segurado number,
			  p_cd_bilhete                 number,
			  p_cd_certificado             number) is
			select sbs.cd_segurado_tmsr
			  from sinistro_busca_segurado sbs
			 where sbs.id_tipo_segurado = p_id_tipo_pessoa
			   and sbs.nr_cgc_cpf_segurado =
			       v_nr_cpf_cnpj_segurado
			   and sbs.nr_estabelecimento_segurado =
			       v_nr_estabelecimento_segurado
			   and sbs.nr_digito_verificador =
			       v_nr_digito_verif_segurado
			      --     OS 785333 - INICIO
			   and (sbs.cd_certificado = p_cd_certificado or
			       p_cd_certificado is null)
			   and (sbs.cd_bilhete = p_cd_bilhete or
			       p_cd_bilhete is null)
			      --     OS 785333 - FIM
			   and sbs.cd_sistema_origem in (2,3)
			   and sbs.cd_companhia_segur_emissao =
			       global_cd_cia_seguradora;
		--Endesa utilizara id_matricula(conta de luz) e  id_cliente(cnpj da Endesa)
		cursor c3(p_id_matricula   varchar2, --Endesa
			  p_id_cliente     varchar2, --Endesa
			  p_cd_bilhete     number,
			  p_cd_certificado number) is
			select sbs.cd_segurado_tmsr
			  from sinistro_busca_segurado sbs
			 where id_cliente = p_id_cliente
			   and nvl(sbs.id_matricula, 0) =
			       lpad(nvl(p_id_matricula, 0),
				    length(sbs.id_matricula),
				    0)
			      --     OS 785333 - INICIO
			   and (sbs.cd_certificado = p_cd_certificado or
			       p_cd_certificado is null)
			   and (sbs.cd_bilhete = p_cd_bilhete or
			       p_cd_bilhete is null)
			      --     OS 785333 - FIM
			   and sbs.cd_sistema_origem in (2,3)
			   and sbs.cd_companhia_segur_emissao =
			       global_cd_cia_seguradora;
		--
	begin
		v_id_unifica_cias := fnc_unificacao_cias;
		--
		if p_dt_ocorrencia is null then
			p_mens := 'Data de ocorrncia não informada.';
			raise v_saida_anormal;
		end if;
		--
		if upper(p_id_cliente) = 'NULL' or p_id_cliente is null then
			v_id_endesa := 'N'; --nao-Endesa
		else
			v_id_endesa := 'S'; --Endesa
		end if;
		if v_id_endesa = 'N' then
			if p_nr_cpf_cnpj_segur is null then
				p_mens := 'Documento do segurado não informado.';
				raise v_saida_anormal;
			end if;
			--
			if p_id_tipo_pessoa_segur = 'J' then
				v_nr_cpf_cnpj_segur_char      := lpad(p_nr_cpf_cnpj_segur,
								      14,
								      0);
				v_nr_cpf_cnpj_segurado        := substr(v_nr_cpf_cnpj_segur_char,
									1,
									8);
				v_nr_estabelecimento_segurado := substr(v_nr_cpf_cnpj_segur_char,
									9,
									4);
				v_nr_digito_verif_segurado    := substr(v_nr_cpf_cnpj_segur_char,
									13,
									2);
				--
			elsif p_id_tipo_pessoa_segur = 'F' then
				v_nr_cpf_cnpj_segur_char      := lpad(p_nr_cpf_cnpj_segur,
								      11,
								      0);
				v_nr_cpf_cnpj_segurado        := substr(v_nr_cpf_cnpj_segur_char,
									1,
									9);
				v_nr_estabelecimento_segurado := 0;
				v_nr_digito_verif_segurado    := substr(v_nr_cpf_cnpj_segur_char,
									10,
									2);
			else
				p_mens := 'Tipo de pessoa ' ||
					  p_id_tipo_pessoa_segur ||
					  ' invlido.';
				raise v_saida_anormal;
			end if;
		end if;
		--

		if p_cd_sessao is null then
			begin
				v_sessao_aws := sini4210_017.fnc_retorna_sessao_web;
			exception
				when others then
					p_mens := 'Problemas ao executar função FNC_RETORNA_SESSAO_WEB - Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
		else
			v_sessao_aws := p_cd_sessao;
		end if;

		p_inicio_busca_tmb := 'Inicio da busca TMB ------------------> ' ||
				      to_char(sysdate,
					      'dd/mm/rrrr hh24:mi:ss');
		if v_id_endesa = 'N' then
			--somente para nao-Endesa
			begin
				sini7910_001.p_busca_re(null,
							--p_cd_local => :p_cd_local,
							null,
							--p_cd_ramo => :p_cd_ramo,
							null,
							--p_cd_apolice => :p_cd_apolice,
							null,
							--p_cd_item_apolice => :p_cd_item_apolice,
							null,
							--p_id_ramo_produto_tmsr => :p_id_ramo_produto_tmsr,
							null,
							--p_id_apolice_tmsr => :p_id_apolice_tmsr,
							null,
							--p_id_item_apolice_tmsr => :p_id_item_apolice_tmsr,
							null,
							--p_id_tipo_endosso_tmsr => :p_id_tipo_endosso_tmsr,
							null,
							--p_id_endosso_tmsr => :p_id_endosso_tmsr,
							v_nr_cpf_cnpj_segurado,
							--p_nr_cpf_cnpj => :p_nr_cpf_cnpj,
							v_nr_estabelecimento_segurado,
							--p_nr_estabelecimento => :p_nr_estabelecimento,
							v_nr_digito_verif_segurado,
							--p_nr_digito_verificador => :p_nr_digito_verificador,
							null,
							--p_ds_segurado => :p_ds_segurado,
							p_dt_ocorrencia,
							--p_dt_ocorrencia => :p_dt_ocorrencia,
							t_item,
							--p_tab_item => p_tab_item,
							p_mens,
							--p_mens => :p_mens,
							null
							--p_id_tipo_operacao => :p_id_tipo_operacao
							);
			exception
				when others then
					p_mens := 'Erro ao tentar executar procedure SINI7910_001.P_BUSCA_RE - Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			if p_mens = 'Não foi encontrado o segurado.' or
			   p_mens is null then
				p_mens := null;
			else
				raise v_saida_anormal;
			end if;
			i := 1;
			while i <= t_item.count loop
				v_ds_produto := null;
				begin
					select p.ds_produto
					  into v_ds_produto
					  from sin_produto p
					 where p.cd_produto = t_item(i)
					      .cd_produto;
				exception
					when others then
						p_mens := 'Problemas ao tentar recuperar descrio da cobertura. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				--
				v_ds_item := null;
				--
				if	nvl(p_retorna_item,'N')	=	'S'	then
					--inicio validacao duplicidade - paulo
					begin
						select count(1)
						  into v_existe
						  from sinistro_busca_apolice a
						 where a.cd_sessao = v_sessao_aws
						   and a.cd_local = t_item(i)
						      .cd_local
						   and a.cd_ramo = t_item(i)
						      .cd_ramo
						   and a.cd_apolice = t_item(i)
						      .cd_apolice
						   and a.cd_item_apolice = t_item(i)
						      .cd_item_apolice;
					exception
						when others then
							v_existe := 0;
					end;

					if t_item(i).ds_endereco_local_risco is null then
						v_ds_item := substr(t_item(i)
								    .ds_rubrica_alternativa,
								    1,
								    200);
					else
						v_ds_item := substr(t_item(i)
								    .ds_endereco_local_risco ||
								     ' - ' || t_item(i)
								    .nr_endereco_risco ||
								     ' - ' || t_item(i)
								    .nm_municipio_local_risco ||
								     ' - ' || t_item(i)
								    .id_uf_local_risco,
								    1,
								    200);
					end if;
				else

					v_existe := 0;
					begin
						select count(1)
						  into v_existe
						  from sinistro_busca_apolice a
						 where a.cd_sessao = v_sessao_aws
						   and a.cd_ramo_produto_tmsr = t_item(i)
						      .p_id_ramo_produto_tmsr
						   and a.cd_apolice_tmsr = t_item(i)
						      .p_id_apolice_tmsr;
					exception
						when others then
							v_existe := 0;
					end;


				end	if;
				--
				if v_existe = 0 then
					--
					begin
						insert into sinistro_busca_apolice
							(cd_sessao,
							 cd_ramo,
							 cd_local,
							 cd_apolice,
							 cd_item_apolice,
							 ds_caracteristica,
							 cd_segurado,
							 nm_segurado,
							 nr_cgc_cpf_segurado,
							 nr_estabelecimento_segurado,
							 nr_digito_verificador,
							 cd_produto,
							 ds_produto,
							 cd_tipo_bem_segurado,
							 cd_caracteristica_bem_segur,
							 cd_ramo_cobertura,
							 dt_inicio_vigencia,
							 dt_termino_vigencia,
							 cd_endosso,
							 id_origem,
							 id_sistema_origem,
							 cd_companhia_segur_emissao,
							 id_tipo_corretor,
							 id_cpf_cnpj_corretor,
							 cd_ramo_produto_tmsr,
							 cd_apolice_tmsr,
							 cd_endosso_tmsr,
							 cd_tipo_endosso_tmsr,
							 cd_item_tmsr,
							 id_chave_acselx)
						values
							(v_sessao_aws,
							 t_item(i).cd_ramo,
							 t_item(i).cd_local,
							 t_item(i).cd_apolice,
							 t_item(i).cd_item_apolice,
							 v_ds_item,
							 t_item(i).cd_segurado,
							 t_item(i).nm_segurado,
							 v_nr_cpf_cnpj_segurado,
							 v_nr_estabelecimento_segurado,
							 v_nr_digito_verif_segurado,
							 t_item(i).cd_produto,
							 v_ds_produto,
							 case when nvl(p_retorna_item,'N') = 'S' then t_item(i).cd_tipo_bem_segurado else null end,
							 case when nvl(p_retorna_item,'N') = 'S' then t_item(i).cd_caracteristica_bem_segur else null end,
							 case when nvl(p_retorna_item,'N') = 'S' then t_item(i).cd_ramo_cobertura else null end,
							 t_item(i).dt_inicio_vigencia,
							 t_item(i).dt_termino_vigencia,
							 t_item(i).cd_endosso,
							 substr(t_item(i)
								.id_origem,
								1,
								1),
							 1, --id_sistema_origem
							 global_cd_cia_seguradora,
							 v_id_tipo_corretor, --id_tipo_corretor
							 t_item(i).nr_cpf_cnpj_corretor,
							 t_item(i).p_id_ramo_produto_tmsr,
							 t_item(i).p_id_apolice_tmsr,
							 t_item(i).p_id_endosso_tmsr,
							 t_item(i).p_id_tipo_endosso_tmsr,
							 case when nvl(p_retorna_item,'N') = 'S' then t_item(i).p_id_item_apolice_tmsr else null end,
							 t_item(i).id_chave_acsel);
					exception
						when others then
							p_mens := 'Problemas ao inserir dados na tabela SINISTRO_BUSCA_APOLICE - Erro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
				end if;
				i := i + 1;
			end loop;
			p_fim_busca_tmb := 'Fim da busca TMB ------------------> ' ||
					   to_char(sysdate,
						   'dd/mm/rrrr hh24:mi:ss');
			commit;
		end if; --p_id_cliente    is null
		-----------------------------------------------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------------------------------------------
		--TMS------------------------------------------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------------------------------------------
		p_inicio_busca_tms := 'Inicio da busca TMS ------------------> ' ||
				      to_char(sysdate,
					      'dd/mm/rrrr hh24:mi:ss');
		if v_id_endesa = 'N' then
			--p_id_cliente null == nao-Endesa
			for r2 in c2(p_id_tipo_pessoa_segur,
				     v_nr_cpf_cnpj_segurado,
				     v_nr_estabelecimento_segurado,
				     v_nr_digito_verif_segurado,
				     p_cd_bilhete,
				     p_cd_certificado) loop
				begin
					v_busca_apolice := sini8050_002.busca_apolice(v_sessao_aws,
										      null,
										      null,
										      null,
										      global_cd_cia_seguradora,
										      null,
										      null,
										      null,
										      null,
										      p_dt_ocorrencia,
										      'C',
										      r2.cd_segurado_tmsr,
										      null,
										      null,
										      null,
										      null,
										      null,
										      v_nr_cpf_cnpj_segur_char--OS Transporte
										      );
				exception
					when others then
						p_mens := 'Erro na chamada da rotina SINI8050_002.BUSCA_APOLICE. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				p_mens := v_busca_apolice;
				if p_mens =
				   'Não foi encontrado o segurado.' or
				   p_mens is null then
					p_mens := null;
				else
					raise v_saida_anormal;
				end if;
			end loop;
		elsif v_id_endesa = 'S' then
			--p_id_cliente preenchido ==> Endesa
			for r2 in c3(p_id_matricula,
				     p_id_cliente,
				     p_cd_bilhete,
				     p_cd_certificado) loop
				begin
					v_busca_apolice := sini8050_002.busca_apolice(v_sessao_aws,
										      null,
										      null,
										      null,
										      global_cd_cia_seguradora,
										      null,
										      null,
										      null,
										      null,
										      p_dt_ocorrencia,
										      'C',
										      r2.cd_segurado_tmsr,
										      null,
										      null,
										      null,
										      null,
										      null,
										      v_nr_cpf_cnpj_segur_char--OS Transporte
										      );
				exception
					when others then
						p_mens := 'Erro na chamada da SINI8050_002.BUSCA_APOLICE-Endesa. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
				p_mens := v_busca_apolice;
				if p_mens =
				   'Não foi encontrado o segurado. ' or
				   p_mens is null then
					p_mens := null;
				else
					raise v_saida_anormal;
				end if;
			end loop;
		end if;
		p_fim_busca_tms := 'Fim da busca TMS ---------------------> ' ||
				   to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
		--limpa auto
		begin
			delete sinistro_busca_apolice sba
			 where sba.cd_sessao = v_sessao_aws
			   and sba.id_sistema_origem in (2,3)
			   and sba.cd_tipo_bem_segurado in (1, 3);
		exception
			when others then
				p_mens := 'Problemas ao tentar excluir dados no RE. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
		--carrega cursor
		--
		v_existe_apolice := 0;
		begin
			select count(1)
			  into v_existe_apolice
			  from sinistro_busca_apolice sba
			 where sba.cd_sessao = v_sessao_aws
			   and nvl(sba.id_cpf_cnpj_corretor,-999) =
			       nvl(p_nr_cpf_cnpj_corre,
				   nvl(sba.id_cpf_cnpj_corretor,-999));
		exception
			when others then
				p_mens := 'Problemas ao validar lista de aplices. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
		if v_existe_apolice = 0 then
			p_mens := 'Nenhuma aplice localizada.';
			raise v_saida_anormal;
		end if;
		--

		begin
			open p_cursor for
				select distinct p_dt_ocorrencia as dt_ocorrencia,
						null as id_origem, --sba.id_origem,
						sba.id_sistema_origem as id_sistema_origem,
						nvl(sba.cd_companhia_segur_emissao,
						    5151) as cd_companhia_segur_emissao,
						null as cd_ramo, --sba.cd_ramo,
						null as cd_local, --sba.cd_local,
						null as cd_apolice, --sba.cd_apolice,
						sba.cd_segurado as cd_segurado,
						sba.nm_segurado as nm_segurado,
						sba.nr_cgc_cpf_segurado as nr_cgc_cpf_segurado,
						sba.nr_estabelecimento_segurado as nr_estabelecimento_segurado,
						sba.nr_digito_verificador as nr_digito_verificador,
						sba.cd_produto as cd_produto,
						sba.ds_produto as ds_produto,
						sba.dt_inicio_vigencia as dt_inicio_vigencia,
						sba.dt_termino_vigencia as dt_termino_vigencia,
						sba.cd_ramo_produto_tmsr as cd_ramo_produto_tmsr,
						sba.cd_apolice_tmsr as cd_apolice_tmsr,
						sba.id_cpf_cnpj_corretor as id_cpf_cnpj_corretor,
						nvl(sba.cd_tipo_endosso_tmsr,0) as cd_tipo_endosso_tmsr,
						sba.cd_endosso_tmsr as cd_endosso_tmsr,

						decode(sba.cd_companhia_segur_emissao,
						       5151,
						       sba.cd_item_apolice,
						       sba.cd_item_tmsr) as cd_item_apolice,
						sba.ds_caracteristica as ds_item_apolice,
						sba.cd_tipo_bem_segurado as cd_tipo_bem_segurado,
						sba.cd_caracteristica_bem_segur as cd_caracteristica_bem_segur,
						sba.cd_ramo_cobertura as cd_ramo_cobertura,
						sba.id_chave_acselx as id_chave_acselx,
						sba.ds_atividade as ds_atividade,
						sba.idepol as idepol
				  from sinistro_busca_apolice sba
				 where sba.cd_sessao = v_sessao_aws
				   and nvl(sba.id_cpf_cnpj_corretor,-999) =
				       nvl(p_nr_cpf_cnpj_corre,
					   nvl(sba.id_cpf_cnpj_corretor,-999));
		exception
			when others then
				p_mens := 'Problemas ao carregar lista de aplices. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
		end;

		--
		begin

			delete sinistro_busca_apolice sba
			 where sba.cd_sessao = v_sessao_aws
			   and sba.id_chave_acselx is null
			   and sba.idepol is null;
			commit;
		exception
			when others then
				p_mens := 'Problemas ao tentar excluir sesso ' ||
					  v_sessao_aws || '. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
	exception
		when v_saida_anormal then
			p_mens := 'PRC_BUSCA_APOLICE_RE_II - ' || p_mens;
		when others then
			p_mens := 'PRC_BUSCA_APOLICE_RE_II - Erro Geral: ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	end;

	/***********************************************************************************
        prc_busca_item_re
            Author  : Paulo Henrique Garcia
            Created : 24/07/2012
            Purpose : Proc que localiza itens da aplice.
            ***********************************************************************************/
	procedure prc_busca_item_re(p_dt_ocorrencia               in date,
				    p_id_sistema_origem           in varchar2,
				    p_cd_companhia_segur_emissao  in number,
				    p_cd_ramo                     in number,
				    p_cd_local                    in number,
				    p_cd_apolice                  in number,
				    p_nm_segurado                 in varchar2,
				    p_nr_cgc_cpf_segurado         in number,
				    p_nr_estabelecimento_segurado in number,
				    p_nr_digito_verificador       in number,
				    p_cd_ramo_produto_tmsr        in number,
				    p_cd_apolice_tmsr             in number,
				    p_nr_cpf_cnpj_corre           in number,
				    p_cursor                      out tab_busca_item_re,
				    p_mens                        out varchar2,
				    p_id_matricula                in varchar2 default null) is
		cursor c2 is
			select distinct sbs.cd_segurado_tmsr
			  from sinistro_busca_segurado sbs
			 where sbs.cd_sistema_origem in (2,3)
			   and sbs.cd_companhia_segur_emissao =
			       global_cd_cia_seguradora
			   and sbs.nr_cgc_cpf_segurado =
			       p_nr_cgc_cpf_segurado
			   and sbs.nr_estabelecimento_segurado =
			       p_nr_estabelecimento_segurado
			   and sbs.nr_digito_verificador =
			       p_nr_digito_verificador
			   and nvl(sbs.id_matricula, 0) =
			       lpad(nvl(p_id_matricula, 0),
				    length(nvl(sbs.id_matricula, 0)),
				    0);
		v_saida_anormal exception;
		t_item            sini7910_001.tab_item;
		v_sessao_aws      varchar2(100) := null;
		v_ds_item         varchar2(200) := null;
		i                 number := null;
		v_busca_apolice   varchar2(1000) := null;
		v_existe_item     number := 0;
		v_id_unifica_cias varchar2(1);
		v_existe          number;
	begin
		--
		v_id_unifica_cias := fnc_unificacao_cias;
		--
		begin
			v_sessao_aws := sini4210_017.fnc_retorna_sessao_web;
		exception
			when others then
				p_mens := 'Problemas ao executar função FNC_RETORNA_SESSAO_WEB - Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
		if p_id_sistema_origem = 1 then
			begin
				sini7910_001.p_busca_re(null,
							--p_cd_local => :p_cd_local,
							null,
							--p_cd_ramo => :p_cd_ramo,
							null,
							--p_cd_apolice => :p_cd_apolice,
							null,
							--p_cd_item_apolice => :p_cd_item_apolice,
							null,
							--p_id_ramo_produto_tmsr => :p_id_ramo_produto_tmsr,
							null,
							--p_id_apolice_tmsr => :p_id_apolice_tmsr,
							null,
							--p_id_item_apolice_tmsr => :p_id_item_apolice_tmsr,
							null,
							--p_id_tipo_endosso_tmsr => :p_id_tipo_endosso_tmsr,
							null,
							--p_id_endosso_tmsr => :p_id_endosso_tmsr,
							p_nr_cgc_cpf_segurado,
							--p_nr_cpf_cnpj => :p_nr_cpf_cnpj,
							p_nr_estabelecimento_segurado,
							--p_nr_estabelecimento => :p_nr_estabelecimento,
							p_nr_digito_verificador,
							--p_nr_digito_verificador => :p_nr_digito_verificador,
							null,
							--p_ds_segurado => :p_ds_segurado,
							p_dt_ocorrencia,
							--p_dt_ocorrencia => :p_dt_ocorrencia,
							t_item,
							--p_tab_item => p_tab_item,
							p_mens,
							--p_mens => :p_mens,
							null
							--p_id_tipo_operacao => :p_id_tipo_operacao
							);
			exception
				when others then
					p_mens := 'Erro ao tentar executar procedure SINI7910_001.P_BUSCA_RE - Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
			if p_mens = 'Não foi encontrado o segurado.' or
			   p_mens is null then
				p_mens := null;
			else
				raise v_saida_anormal;
			end if;
			i := 1;
			while i <= t_item.count loop
				if t_item(i).ds_endereco_local_risco is null then
					v_ds_item := substr(t_item(i)
							    .ds_rubrica_alternativa,
							    1,
							    200);
				else
					v_ds_item := substr(t_item(i)
							    .ds_endereco_local_risco ||
							     ' - ' || t_item(i)
							    .nr_endereco_risco ||
							     ' - ' || t_item(i)
							    .nm_municipio_local_risco ||
							     ' - ' || t_item(i)
							    .id_uf_local_risco,
							    1,
							    200);
				end if;
				--inicio paulo duplicidade apolice
				v_existe := 0;
				begin
					select count(1)
					  into v_existe
					  from sinistro_busca_apolice a
					 where a.cd_sessao = v_sessao_aws
					   and a.cd_local = t_item(i)
					      .cd_local
					   and a.cd_ramo = t_item(i)
					      .cd_ramo
					   and a.cd_apolice = t_item(i)
					      .cd_apolice
					   and a.cd_item_apolice = t_item(i)
					      .cd_item_apolice;
				exception
					when others then
						v_existe := 0;
				end;
				if v_existe = 0 then
					begin
						insert into sinistro_busca_apolice
							(cd_sessao,
							 cd_ramo,
							 cd_local,
							 cd_apolice,
							 cd_item_apolice,
							 ds_caracteristica,
							 cd_segurado,
							 nm_segurado,
							 nr_cgc_cpf_segurado,
							 nr_estabelecimento_segurado,
							 nr_digito_verificador,
							 cd_produto,
							 ds_produto,
							 cd_tipo_bem_segurado,
							 cd_caracteristica_bem_segur,
							 cd_ramo_cobertura,
							 dt_inicio_vigencia,
							 dt_termino_vigencia,
							 cd_endosso,
							 id_origem,
							 id_sistema_origem,
							 cd_companhia_segur_emissao,
							 id_cpf_cnpj_corretor,
							 cd_ramo_produto_tmsr,
							 cd_apolice_tmsr,
							 cd_endosso_tmsr,
							 cd_tipo_endosso_tmsr,
							 cd_item_tmsr,
							 id_chave_acselx)
						values
							(v_sessao_aws,
							 t_item(i).cd_ramo,
							 t_item(i).cd_local,
							 t_item(i)
							 .cd_apolice,
							 t_item(i)
							 .cd_item_apolice,
							 v_ds_item,
							 t_item(i)
							 .cd_segurado,
							 t_item(i)
							 .nm_segurado,
							 t_item(i)
							 .nr_cpf_cnpj,
							 t_item(i)
							 .nr_estabelecimento,
							 t_item(i)
							 .nr_digito_verificador,
							 t_item(i)
							 .cd_produto,
							 t_item(i)
							 .ds_produto,
							 t_item(i)
							 .cd_tipo_bem_segurado,
							 t_item(i)
							 .cd_caracteristica_bem_segur,
							 t_item(i)
							 .cd_ramo_cobertura,
							 t_item(i)
							 .dt_inicio_vigencia,
							 t_item(i)
							 .dt_termino_vigencia,
							 t_item(i)
							 .cd_endosso,
							 substr(t_item(i)
								.id_origem,
								1,
								1),
							 1,
							 global_cd_cia_seguradora,
							 p_nr_cpf_cnpj_corre,
							 t_item(i)
							 .p_id_ramo_produto_tmsr,
							 t_item(i)
							 .p_id_apolice_tmsr,
							 t_item(i)
							 .p_id_endosso_tmsr,
							 t_item(i)
							 .p_id_tipo_endosso_tmsr,
							 t_item(i)
							 .p_id_item_apolice_tmsr,
							 t_item(i)
							 .id_chave_acsel);
					exception
						when others then
							p_mens := 'Problemas ao inserir dados na tabela SINISTRO_BUSCA_APOLICE - Erro: ' ||
								  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
							raise v_saida_anormal;
					end;
				end if;
				i := i + 1;
			end loop;
			commit;
		elsif p_id_sistema_origem in (2,3) then
			for r2 in c2 loop
				begin
					v_busca_apolice := sini8050_002.busca_apolice(v_sessao_aws,
										      null,
										      null,
										      null,
										      global_cd_cia_seguradora,
										      null,
										      null,
										      null,
										      null,
										      p_dt_ocorrencia,
										      'C',
										      r2.cd_segurado_tmsr,
										      null,
										      null,
										      null,
										      null,
										      null,
										      case when p_nr_estabelecimento_segurado is null then lpad(p_nr_cgc_cpf_segurado,9,0)||lpad(p_nr_digito_verificador,2,0) else lpad(p_nr_cgc_cpf_segurado,8,0)||lpad(p_nr_estabelecimento_segurado,4,0)||lpad(p_nr_digito_verificador,2,0) end --OS Transporte
										      );
				exception
					when others then
						p_mens := 'Erro na chamada da rotina SINI8050_002.BUSCA_APOLICE. Erro: ' ||
							  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise v_saida_anormal;
				end;
			end loop;
			p_mens := v_busca_apolice;
			if p_mens = 'Não foi encontrado o segurado.' or
			   p_mens is null then
				p_mens := null;
			else
				raise v_saida_anormal;
			end if;
		else
			p_mens := 'Cdigo de sistema origem ' ||
				  p_id_sistema_origem || ' invlido.';
			raise v_saida_anormal;
		end if;
		--carrega cursor
		v_existe_item := 0;
		begin
			select count(1)
			  into v_existe_item
			  from sinistro_busca_apolice sba
			 where sba.cd_sessao = v_sessao_aws;
		exception
			when others then
				p_mens := 'Problemas ao validar itens da aplice. Erro: ' ||
					  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				raise v_saida_anormal;
		end;
		if v_existe_item = 0 then
			p_mens := 'Nenhum item localizado para esta aplice.';
			raise v_saida_anormal;
		end if;
		--
		if v_id_unifica_cias = 'S' then
			begin
				update sinistro_busca_apolice sba
				   set sba.ds_caracteristica = sba.ds_produto
				 where sba.cd_sessao = v_sessao_aws
				   and nvl(sba.cd_ramo_produto_tmsr, 0) =
				       nvl(p_cd_ramo_produto_tmsr, 0)
				   and nvl(sba.cd_apolice_tmsr, 0) =
				       nvl(p_cd_apolice_tmsr, 0)
				   and sba.ds_caracteristica is null;
			exception
				when others then
					p_mens := 'Problemas ao tentar atualizar a descrio do item. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;

		end if;
		--exclui itens duplicados
		for r3 in (select count(1),
				  sba.cd_sessao,
				  sba.cd_ramo,
				  sba.cd_local,
				  sba.cd_apolice,
				  sba.cd_item_apolice
			     from sinistro_busca_apolice sba
			    where sba.cd_sessao = v_sessao_aws
			    group by sba.cd_sessao,
				     sba.cd_ramo,
				     sba.cd_local,
				     sba.cd_apolice,
				     sba.cd_item_apolice
			   having count(1) > 1) loop
			begin
				delete sinistro_busca_apolice sba
				 where sba.cd_sessao = v_sessao_aws
				   and sba.cd_ramo = r3.cd_ramo
				   and sba.cd_local = r3.cd_local
				   and sba.cd_apolice = r3.cd_apolice
				   and sba.cd_item_apolice =
				       r3.cd_item_apolice
				   and sba.dt_inicio_vigencia =
				       (select min(sba.dt_inicio_vigencia)
					  from sinistro_busca_apolice sba
					 where sba.cd_sessao = v_sessao_aws
					   and sba.cd_ramo = r3.cd_ramo
					   and sba.cd_local = r3.cd_local
					   and sba.cd_apolice =
					       r3.cd_apolice
					   and sba.cd_item_apolice =
					       r3.cd_item_apolice)
				   and rownum = 1;
			exception
				when others then
					p_mens := 'Problemas ao excluir itens duplicados. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;
		end loop;
		--
		if v_id_unifica_cias = 'S' then
			begin
				open p_cursor for
					select distinct decode(p_cd_companhia_segur_emissao,
							       5151,
							       sba.cd_item_apolice,
							       sba.cd_item_tmsr),
							sba.ds_caracteristica,
							sba.cd_tipo_bem_segurado,
							sba.cd_caracteristica_bem_segur,
							sba.cd_ramo_cobertura,
							sba.id_chave_acselx,
							sba.id_sistema_origem,
							sba.idepol,--OS Transporte
							p_dt_ocorrencia--OS Transporte
							, sba.ds_local_risco	-- SinistroDigitalResidencial
					  from sinistro_busca_apolice sba
					 where sba.cd_sessao = v_sessao_aws
					   and nvl(sba.cd_ramo_produto_tmsr,
						   0) = nvl(p_cd_ramo_produto_tmsr,
							    0)
					   and nvl(sba.cd_apolice_tmsr, 0) =
					       nvl(p_cd_apolice_tmsr, 0);
			exception
				when others then
					p_mens := 'Problemas ao tentar carregar lista de itens. Erro: ' ||
						  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					raise v_saida_anormal;
			end;

		end if;
		--
		delete sinistro_busca_apolice sba
		 where sba.cd_sessao = v_sessao_aws
		   and sba.id_chave_acselx is null;
		--
	exception
		when v_saida_anormal then
			p_mens := 'PRC_BUSCA_ITEM_RE - ' || p_mens;
		when others then
			p_mens := 'Erro Geral: ' || DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	end;

	--
	/***********************************************************************************
        prc_exibe_apolice
            Author  : Juliano Antonietto
            Created :  04/10/2017
            Purpose : Retonar 1 para exibir a aplice para a modalidade informada, ou 0 para
            não exibir no sistema.

        ***********************************************************************************/
	procedure prc_exibe_apolice(p_cd_tipo_bem_segurado   in number,
				    p_cd_carac_bem_segur     in number,
				    p_cd_ramo                in number,
				    p_cd_ramo_produto        in number,
				    p_cd_modalidade_sinistro in number,
				    --
				    p_id_exibe out number,
				    p_mens     out varchar2) is
		--
		v_conta_modal number := 0;
		--
	begin
		begin
			select count(*)
			  into v_conta_modal
			  from sinistro_ramo_modalidade mod
			 where mod.cd_tipo_bem_segurado =
			       p_cd_tipo_bem_segurado
			   and mod.cd_caracteristica_bem_segur =
			       p_cd_carac_bem_segur
			   and mod.cd_ramo = p_cd_ramo
			   and mod.cd_modalidade_sinistro =
			       p_cd_modalidade_sinistro
			   and nvl(mod.cd_ramo_produto, p_cd_ramo_produto) =
			       p_cd_ramo_produto;
		exception
			when others then
				v_conta_modal := 0;
		end;
		--
		if nvl(v_conta_modal, 0) > 0 then
			--
			p_id_exibe := 1;
		else
			--
			p_id_exibe := 0;
			--
		end if;
	exception
		when others then
			p_mens := 'SINI7070_008.p_mens - Erro Geral - ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			return;
	end;

	--
	/***********************************************************************************
        Author  : Juliano Antonietto
        Created : 27/11/2017.
        Purpose : Procedure que realiza a busca na base por matricula, aviso ou cfp, retornando
        uma LIsta de Itens de Aviso.
        ***********************************************************************************/
	--
	procedure prc_lista_avisos(p_id_matricula                in varchar2,
				   p_cd_aviso                    in number,
				   p_nr_cpf_sinistrado           in number,
				   p_nr_digito_verificador_sinis in number,
				   p_nr_estabelecimento_segur    in number,
				   p_cod_retorno                 out number, -- Se retornar <> de "null", considerar como "|Erro"
				   p_ds_retorno                  out varchar2, -- Se retornar <> de "null", considerar como "|Erro"
				   p_cursor                      out tab_dados_aviso) is
		--
	begin
		--
		open p_cursor for
		--
			select ele.cd_pre_aviso_sinistro,
			       ele.cd_reclamacao_elementar --,
			--     seg.*
			  from sinistro_busca_segurado   seg,
			       sin_apolice_item          it,
			       sinistro_reclamacao_eleme ele
			 where (((p_nr_cpf_sinistrado is not null and
			       p_nr_digito_verificador_sinis is not null and
			       p_cd_aviso is null and
			       p_id_matricula is null) and
			       (seg.nr_cgc_cpf_segurado =
			       p_nr_cpf_sinistrado and
			       seg.nr_digito_verificador =
			       p_nr_digito_verificador_sinis and
			       nvl(seg.nr_estabelecimento_segurado, 0) =
			       nvl(p_nr_estabelecimento_segur, 0)
			       --seg.id_matricula             =     p_id_matricula
			       )) or
			       ((p_nr_cpf_sinistrado is not null and
			       p_nr_digito_verificador_sinis is not null and
			       p_id_matricula is not null) and
			       (seg.nr_cgc_cpf_segurado =
			       p_nr_cpf_sinistrado and
			       seg.nr_digito_verificador =
			       p_nr_digito_verificador_sinis and
			       nvl(seg.nr_estabelecimento_segurado, 0) =
			       nvl(p_nr_estabelecimento_segur, 0)
			       --seg.id_matricula             =     p_id_matricula
			       )) or ((p_nr_cpf_sinistrado is null and
			       p_nr_digito_verificador_sinis is null and
			       p_cd_aviso is null and
			       p_id_matricula is not null) and
			       (seg.id_matricula = p_id_matricula)) or
			       ((p_cd_aviso is not null) and
			       (ele.cd_reclamacao_elementar = p_cd_aviso)))
			      --
			   and ele.id_apolice_tmsr = it.cd_apolice
			   and ele.id_endosso_tmsr = it.cd_endosso
			   and ele.id_tipo_endosso_tmsr =
			       it.cd_tipo_endosso
			   and ele.id_item_tmsr = it.cd_item_apolice
			   and ele.id_ramo_produto_tmsr =
			       it.cd_ramo_produto
			   and ele.cd_cia_seguradora =
			       it.cd_companhia_segur_emissao
			   and ele.id_sistema_origem = it.cd_sistema_origem
			      --
			   and seg.cd_segurado = it.cd_segurado
			   and seg.cd_sistema_origem = it.cd_sistema_origem --;
			--;
			--     Avisos  sem apolice...        sinistro_pre_aviso
			--
			union
			--
			select pr.cd_pre_aviso_sinistro,
			       ele.cd_reclamacao_elementar
			  from sinistro_reclamacao_eleme ele,
			       sinistro_pre_aviso        pr --,
			--     sinistro_certificado                  cert
			 where (((p_nr_cpf_sinistrado is not null and
			       p_nr_digito_verificador_sinis is not null and
			       p_cd_aviso is null and
			       p_id_matricula is null) and
			       (ele.nr_cgc_cpf_segurado =
			       p_nr_cpf_sinistrado and
			       ele.nr_digito_verificador =
			       p_nr_digito_verificador_sinis and
			       nvl(ele.nr_estabelecimento_segurado, 0) =
			       nvl(p_nr_estabelecimento_segur, 0) and
			       ele.id_matricula = p_id_matricula)) or
			       ((p_nr_cpf_sinistrado is null and
			       p_nr_digito_verificador_sinis is null and
			       p_cd_aviso is null and
			       p_id_matricula is not null) and
			       (ele.id_matricula = p_id_matricula or
			       pr.id_matricula = p_id_matricula)) or
			       ((p_nr_cpf_sinistrado is not null and
			       p_nr_digito_verificador_sinis is not null and
			       p_id_matricula is not null) and
			       (
			       --ele.id_matricula             =     p_id_matricula        --or
				pr.id_matricula = p_id_matricula)) or
			       ((p_cd_aviso is not null) and
			       (ele.cd_reclamacao_elementar = p_cd_aviso or
			       pr.cd_pre_aviso_sinistro = p_cd_aviso)) or
			       ((p_nr_cpf_sinistrado is not null and
			       p_nr_digito_verificador_sinis is not null and
			       p_cd_aviso is null) and (pr.nr_cpf_sinistrado =
			       p_nr_cpf_sinistrado and
			       pr.nr_digito_verific_segurado =
			       p_nr_digito_verificador_sinis --and
			       --       nvl(pr.id_matricula, 0)             = nvl(p_id_matricula, 0)
			       )) or ((p_id_matricula is not null) and
			       exists (select 1
						from sinistro_certificado cert
					       where cert.cd_matricula_funcionario =
						     p_id_matricula
						 and cert.cd_reclamacao_elementar =
						     ele.cd_reclamacao_elementar
					      --
					      --       nvl(pr.id_matricula, 0)             = nvl(p_id_matricula, 0)
					      )))
			   and ele.cd_pre_aviso_sinistro(+) =
			       pr.cd_pre_aviso_sinistro;
		--
		--
	exception
		when others then
			--
			p_ds_retorno  := 'sini7070_008.prc_lista_aviso - Erro ao Popular lista de avisos - Exception Oracle: ' ||
					 DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			p_cod_retorno := '99'; -- Forar codigo de erro.
	end;

	--
	--
	/***********************************************************************************
        Author  : Heryson Prestes
        Created : 21/07/20120.
        Purpose : carrega dados da RC Ambiental
        ***********************************************************************************/
	--
	procedure prc_detalhe_rc_ambiental(p_cd_reclamacao_elementar  in number,
					   p_benefsinis_assistencia   out varchar2,
					   p_beneficiario_refer_nome  out varchar2,
					   p_beneficiario_refer_email out varchar2,
					   p_beneficiario_outro_nome  out varchar2,
					   p_beneficiario_outro_email out varchar2,
					   p_mens                     out varchar2) is
		--
		--
	begin
		--
		select a.cd_benefsinis_assistencia,
		       b.nm_beneficiario,
		       e.id_email,
		       a.nm_outro_prest_assistencia,
		       a.id_email_prest_assistencia

		  into p_benefsinis_assistencia,
		       p_beneficiario_refer_nome,
		       p_beneficiario_refer_email,
		       p_beneficiario_outro_nome,
		       p_beneficiario_outro_email

		  from sinistro_reclamacao_eleme     a,
		       sinistro_beneficiario         b,
		       sinistro_beneficiario_contato c,
		       sinistro_benef_contato_telef  d,
		       sinistro_benef_contato_email  e

		 where a.cd_benefsinis_assistencia =
		       b.cd_beneficiario_sinistro(+)
		   and b.cd_beneficiario_sinistro =
		       c.cd_beneficiario_sinistro(+)
		   and c.cd_benef_contato_sinistro =
		       d.cd_benef_contato_sinistro(+)
		   and d.cd_benef_contato_sinistro =
		       e.cd_benef_contato_sinistro(+)
		   and a.cd_reclamacao_elementar =
		       p_cd_reclamacao_elementar;
		--
	exception
		--
		when others then
			p_mens := 'prc_detalhe_rc_ambiental - Erro Geral: ' ||
				  DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
			return;
	end;
	--
	--
	/******************************************************************************
        Autor: Heryson Prestes / Data.: 23/07/2020
        Desc: envia e-mail com checklist de rc ambiental para os casos de re padro GNT
        *******************************************************************************/
	--
	procedure prc_email_rc_ambiental(p_nravisosinistro    in varchar2,
					 p_dsobservacao       in varchar2,
					 p_destinatario       in varchar2,
					 p_datahora           in varchar2,
					 p_nomecomunicante    in varchar2,
					 p_nomeempresa        in varchar2,
					 p_cpfcnpj            in varchar2,
					 p_email              in varchar2,
					 p_telefone           in varchar2,
					 p_ramoapolice        in varchar2,
					 p_endereco           in varchar2,
					 p_areaafetada        in varchar2,
					 p_dscocorrencia      in varchar2,
					 p_placa              in varchar2,
					 p_modeloveiculo      in varchar2,
					 p_produtoenvolvacide in varchar2,
					 p_numonu             in varchar2,
					 p_qtdprodenvolvido   in varchar2,
					 p_problemamecanico   in varchar2,
					 p_tpsinistro         in varchar2,
					 p_possuivazamento    in varchar2,
					 p_volumelitros       in varchar2,
					 p_atingiumares       in varchar2,
					 p_houvevitimas       in varchar2,
					 p_presencaorgao      in varchar2,
					 p_noapolice          in varchar2,
					 p_retorno            out varchar2,
					 p_msg                out varchar2) is
		--
		v_json_envio             json;
		v_url_do_ws_rest         varchar2(5000);
		v_retorno_do_web_service varchar2(8000);
		--
	begin
		--
		begin
			--
			select w.ds_valor
			  into v_url_do_ws_rest
			  from wf_config w
			 where w.cd_config = 'url.gnt.checklist.rc.service';
			--
		exception
			--
			when others then
				p_msg := 'erro na prc_email_rc_ambiental - Erro Geral: ' ||
					 DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
				--
		end;
		--

		--
		begin
			--
			v_json_envio := json();
			v_json_envio.put('nrAvisoSinistro',
					 p_nravisosinistro);
			v_json_envio.put('dsObservacao', p_dsobservacao);
			v_json_envio.put('codigo', 'EMSINOUTR0002');
			v_json_envio.put('tipoEnvio', 'AMBOS');
			v_json_envio.put('rastreiaEnvio', 'S');
			v_json_envio.put('emailRemetente',
					 'noreply@tokiomarine.com.br');
			v_json_envio.put('destinatario', p_destinatario); --p_destinatario
			v_json_envio.put('nomeParametro', 'ASSUNTO');
			v_json_envio.put('valorParametro',
					 'Prezado Prestador, Na data de hoje foi formalizado o Aviso de Sinistro - RC Ambiental No ' ||
					 p_nravisosinistro ||
					 ' conforme informaes Anexa');
			v_json_envio.put('dataHora', p_datahora);
			v_json_envio.put('nomeComunicante',
					 p_nomecomunicante);
			v_json_envio.put('nomeEmpresa', p_nomeempresa);
			v_json_envio.put('cpfCnpj', p_cpfcnpj);
			v_json_envio.put('eMail', p_email);
			v_json_envio.put('noApolice', p_noapolice);
			v_json_envio.put('telefone', p_telefone);
			v_json_envio.put('ramoApolice', p_ramoapolice);
			v_json_envio.put('endereco', p_endereco);
			v_json_envio.put('areaAfetada', p_areaafetada);
			v_json_envio.put('dscOcorrencia', p_dscocorrencia);
			v_json_envio.put('placa', p_placa);
			v_json_envio.put('modeloVeiculo', p_modeloveiculo);
			v_json_envio.put('produtoEnvolvAcide',
					 p_produtoenvolvacide);
			v_json_envio.put('numOnu', p_numonu);
			v_json_envio.put('qtdProdEnvolvido',
					 p_qtdprodenvolvido);
			v_json_envio.put('problemaMecanico',
					 p_problemamecanico);
			v_json_envio.put('tpSinistro', p_tpsinistro);
			v_json_envio.put('possuiVazamento',
					 p_possuivazamento);
			v_json_envio.put('volumeLitros', p_volumelitros);
			v_json_envio.put('atingiuMares', p_atingiumares);
			v_json_envio.put('houveVitimas', p_houvevitimas);
			v_json_envio.put('presencaOrgao', p_presencaorgao);

			-- servico de envio de email
			admtms.tms_rest.prc_chamar_ws_json(v_url_do_ws_rest,
							   v_json_envio,
							   'POST',
							   v_retorno_do_web_service,
							   false);
			p_retorno := v_retorno_do_web_service;
			--
		exception
			--
			when others then
				p_msg := 'erro na prc_email_rc_ambiental.';
				--
		end;
		null;
		--
	end;
	--
	/******************************************************************************
        Autor: Marcio Reis / Data.: 18/11/2020
        Desc: realiza a chamada da gerao de relatrios aps gerar o aviso (via Job TWS)
        *******************************************************************************/
	--
	procedure prc_gera_relatorios(p_mens	out	varchar2)	is
		--
		cursor	c0	is
		select	a.*,
			b.id_sistema_origem,
			b.cd_cia_seguradora,
			b.id_ramo_produto_tmsr,
			b.id_apolice_tmsr,
			b.id_tipo_endosso_tmsr,
			b.id_endosso_tmsr,
			b.id_item_tmsr,
			b.cd_letra_sinistro,
			b.cd_local_contabil,
			b.cd_tipo_bem_segurado,
			b.cd_caracteristica_bem_segur,
			b.cd_sinistro,
			b.cd_natureza_sinistro,
			b.dt_ocorrencia,
			b.id_rollout,
			b.cd_analista_sinistro,
			b.cd_produto_tmsr,
			b.cd_funcionario,
			b.cd_letra_sinistro||b.cd_local_contabil||lpad(b.cd_ramo,2,0)||lpad(b.cd_sinistro,8,0)nr_sinistro
		from	sinistro_relatorios		a,
			sinistro_reclamacao_eleme	b
		where	a.cd_aviso		=	b.cd_reclamacao_elementar
		and	a.id_extracao	=	'N';
		--
		v_aux_varchar		varchar2(1000);
		v_aux_number		number;
		v_aux_date		date;
		v_mens_log_erro		varchar2(4000);
		v_saida_anormal		exception;
		--
		--##(SS-1420) variaveis do e-mail com checklist rc ambiental ##
		vrc_ds_observacao              varchar2(4000) := null;
		vrc_id_email_segurado          varchar2(1000) := null;
		vrc_dt_ocorrencia              varchar2(100) := null;
		vrc_nm_informante_reclamacao   varchar2(1000) := null;
		vrc_nm_segurado                varchar2(1000) := null;
		vrc_nr_cgc_cpf_segurado        varchar2(100) := null;
		vrc_nr_estab_segurado          varchar2(100) := null;
		vrc_nr_digito_verificador      varchar2(100) := null;
		vrc_nr_ddd_segurado            varchar2(100) := null;
		vrc_nr_telefone_segurado       varchar2(100) := null;
		vrc_ds_local_ocorrencia        varchar2(4000) := null;
		vrc_nm_bairro_ocorrencia       varchar2(1000) := null;
		vrc_nm_municipio_ocorrencia    varchar2(1000) := null;
		vrc_id_unidade_federacao_ocorr varchar2(100) := null;
		vrc_ds_ocorrencia              varchar2(4000) := null;
		vrc_cd_benefsinis_assistencia  varchar2(1000) := null;
		vrc_nm_beneficiario            varchar2(1000) := null;
		vrc_id_email                   varchar2(1000) := null;
		vrc_nm_outro_prest_assistencia varchar2(1000) := null;
		vrc_id_email_prest_assistencia varchar2(1000) := null;
		vrc_destinatario               varchar2(1000) := null;
		vrc_retorno                    varchar2(1000) := null;
		vrc_msg                        varchar2(1000) := null;
		vcr_noapolice                  varchar2(100) := null;
		--
	begin
		--
		DBMS_OUTPUT.disable;
		for	r0	in	c0	loop
			--
			begin
			-- PROCEDURE QUE GERA OS RELATRIOS E ENVIA E-MAIL.
				begin
					sini7070_006.post_db_commit(r0.cd_aviso,
								    --p_cd_reclamacao_elementar    in         number
								    'S',
								    --p_p_inclusao            in        varchar2
								    r0.id_sistema_origem,
								    --p_id_sistema_origem        in        number
								   null,
								    --p_cd_corretor            in        number
								    case when r0.id_apolice_tmsr = null then 'N' else 'S' end,
								    --p_id_achou_apolice        in        varchar2
								    'N',
								    --p_id_rollout            in        varchar2
								    r0.id_tipo_operacao,
								    --p_p_id_tipo_operacao        in        number
								    r0.id_existe_email_corretor,
								    --p_id_existe_email_corretor    in        varchar2
								    'N',
								    --p_p_desativa_rel_email    in        varchar2
								    v_aux_varchar,
								    --p_p_sini7080            in    out    varchar2
								    r0.cd_local_contabil,
								    --p_id_local_contabil        in                 number
								    r0.cd_tipo_bem_segurado,
								    --p_cd_tipo_bem_segurado        in        number
								    r0.cd_caracteristica_bem_segur,
								    --p_cd_caracteristica_bem_segur    in        number
								    r0.cd_ramo,
								    --p_id_ramo                     in        number
								    r0.cd_sinistro,
								    --p_id_sinistro                 in        number
								    case when r0.id_rollout = 'N' then 1 else null end,
								    --p_id_situacao            in        number
								    v_aux_number,
								    --p_cd_endosso            in    out    number
								    v_aux_number,
								    --p_cd_produto                  in    out    number
								    v_aux_number,
								    --p_cd_produto_arquivo        in    out    number
								    v_aux_number,
								    --p_cd_produto_historico        in    out    number
								    r0.cd_produto_tmsr,
								    --p_cd_produto_tmsr             in    out    number
								    r0.cd_cia_seguradora,
								    --p_cd_cia_seguradora        in        number
								    null,
								    --p_cd_ramo                 in        number
								    null,
								    --p_cd_local                in        number
								    null,
								    --p_cd_apolice              in        number
								    null,
								    --p_cd_item_apolice         in        number
								    null,
								    --p_cd_ramo_apolice         in        number
								    r0.id_apolice_tmsr,
								    --p_id_apolice_tmsr         in        number
								    r0.id_tipo_endosso_tmsr,
								    --p_id_tipo_endosso_tmsr    in        number
								    r0.id_endosso_tmsr,
								    --p_id_endosso_tmsr         in        number
								    r0.id_item_tmsr,
								    --p_id_item_tmsr            in        number
								    r0.id_ramo_produto_tmsr,
								    --p_id_ramo_produto_tmsr    in        number
								    r0.dt_ocorrencia,
								    --p_dt_ocorrencia           in        date
								    v_aux_date,
								    --p_dt_historico_arquivo    in    out    date
								    r0.cd_letra_sinistro,
								    --p_id_letra_sinistro        in        varchar2
								    v_aux_varchar,
								    --p_p_sini8150            in    out    varchar2
								    v_aux_varchar,
								    --p_p_sini4205            in    out    varchar2
								    'S',
								    --p_g_enviar_email_analista    in        varchar2
								    v_aux_varchar,
								    --p_ds_mensagem_corretor    in        varchar2
								    r0.id_email_analista,
								    --p_id_email_analista        in        varchar2
								    r0.cd_vistoriador_sinistro,
								    --p_cd_vistoriador_sinistro    in        number
								    r0.id_situacao_abertura,
								    --p_id_situacao_abertura    in        varchar2
								    r0.nm_vistoriador_sinistro,
								    --p_nm_vistoriador_sinistro    in    out    varchar2
								    r0.id_email_vistoriador,
								    --p_id_email_vistoriador    in    out    varchar2
								    r0.cd_funcionario,
								    --p_cd_funcionario        in        number
								    r0.cd_analista_sinistro,
								    --p_cd_analista_sinistro    in        number
								    1,
								    --p_id_tipo_processo        in        number
								    v_aux_varchar,
								    --p_id_analista_distr_vist    in        varchar2
								    r0.st_registro,
								    --p_g_st_registro        in    out    number
								    'S',
								    --p_aviso_web
								    r0.cd_natureza_sinistro,
								    --p_cd_natureza
								    p_mens,
								    --p_mens                out    varchar2
								    v_aux_varchar,
								    --p_mens_aviso                out    varchar2
								    v_aux_varchar,
								    --p_mens_aviso_2            out    varchar2
								    v_aux_varchar,
								    --p_mens_aviso_3            out    varchar2
								    v_aux_varchar,
								    --p_mens_aviso_4                        out    varchar2
								    v_aux_varchar
								    --p_mens_aviso_5                        out    varchar2
								    );
				exception
					when	others	then
						--
						p_mens	:=	'Problemas ao executar procedure SINI7070_006.POST_DB_COMMIT. ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise	v_saida_anormal;
						--
				end;
				--
				--## (SS-1420) envia e-mail no formato GNT com checklist de rc ambiental ##
				begin
					--SS-1661
					if	r0.cd_ramo	=	13	then
						-- busca os dados para o envio do e-mail
						begin
							--
							select a.ds_observacao,
							       a.id_email_segurado,
							       a.dt_ocorrencia,
							       a.nm_informante_reclamacao,
							       c.nm_segurado,
							       c.nr_cgc_cpf_segurado,
							       c.nr_estabelecimento_segurado,
							       c.nr_digito_verificador,
							       a.nr_ddd_segurado,
							       a.nr_telefone_segurado,
							       a.ds_endereco_vistoria,
							       a.nm_bairro_vistoria,
							       a.nm_municipio_vistoria,
							       a.id_unidade_federacao_vistor,
							       a.ds_ocorrencia,
							       a.cd_benefsinis_assistencia,
							       e.nm_beneficiario,
							       h.id_email,
							       a.nm_outro_prest_assistencia,
							       a.id_email_prest_assistencia,
							       b.cd_apolice
							  into vrc_ds_observacao,
							       vrc_id_email_segurado,
							       vrc_dt_ocorrencia,
							       vrc_nm_informante_reclamacao,
							       vrc_nm_segurado,
							       vrc_nr_cgc_cpf_segurado,
							       vrc_nr_estab_segurado,
							       vrc_nr_digito_verificador,
							       vrc_nr_ddd_segurado,
							       vrc_nr_telefone_segurado,
							       vrc_ds_local_ocorrencia,
							       vrc_nm_bairro_ocorrencia,
							       vrc_nm_municipio_ocorrencia,
							       vrc_id_unidade_federacao_ocorr,
							       vrc_ds_ocorrencia,
							       vrc_cd_benefsinis_assistencia,
							       vrc_nm_beneficiario,
							       vrc_id_email,
							       vrc_nm_outro_prest_assistencia,
							       vrc_id_email_prest_assistencia,
							       vcr_noapolice
							  from sinistro_reclamacao_eleme     a,
							       sin_apolice_item              b,
							       sin_segurado                  c,
							       sinistro_natureza             d,
							       sinistro_beneficiario         e,
							       sinistro_beneficiario_contato f,
							       sinistro_benef_contato_telef  g,
							       sinistro_benef_contato_email  h
							 where a.id_apolice_tmsr	=	b.cd_apolice
							   and a.id_endosso_tmsr =
							       b.cd_endosso
							   and a.id_item_tmsr =
							       b.cd_item_apolice
							   and b.cd_segurado =
							       c.cd_segurado
							   --
							   and b.cd_sistema_origem =
							       c.cd_sistema_origem
							   --
							   and b.cd_ramo_produto =
							       a.id_ramo_produto_tmsr
							   and a.cd_natureza_sinistro =
							       d.cd_natureza_sinistro
							   and a.cd_benefsinis_assistencia =
							       e.cd_beneficiario_sinistro(+)
							   and e.cd_beneficiario_sinistro =
							       f.cd_beneficiario_sinistro(+)
							   and f.cd_benef_contato_sinistro =
							       g.cd_benef_contato_sinistro(+)
							   and g.cd_benef_contato_sinistro =
							       h.cd_benef_contato_sinistro(+)
							   and a.cd_reclamacao_elementar =
							       r0.cd_aviso;

							if	vrc_cd_benefsinis_assistencia	is	not	null	then
								--
								vrc_destinatario	:=	r0.id_email_analista;
								--
							else
								--
								vrc_destinatario	:=	vrc_id_email_prest_assistencia;
								--
							end if;
							--
						exception
							--
							when	others	then
								--
								p_mens	:=	'Problemas ao consultar tabela sinistro_reclamacao_eleme. Erro: ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise	v_saida_anormal;
								--
						end;
						--
						-- chama a proc de envio de e-mail
						begin
							--
							sini7070_008.prc_email_rc_ambiental(r0.cd_aviso,
											    vrc_ds_observacao,
											    vrc_destinatario,
											    vrc_dt_ocorrencia,
											    vrc_nm_informante_reclamacao,
											    vrc_nm_segurado,
											    vrc_nr_cgc_cpf_segurado ||
											    to_char(vrc_nr_estab_segurado,
												    '0000') ||
											    to_char(vrc_nr_digito_verificador,
												    '00'),
											    vrc_id_email_segurado,
											    vrc_nr_ddd_segurado ||
											    vrc_nr_telefone_segurado,
											    null,
											    vrc_ds_local_ocorrencia || ', ' ||
											    vrc_nm_bairro_ocorrencia || ', ' ||
											    vrc_nm_municipio_ocorrencia || ', ' ||
											    vrc_id_unidade_federacao_ocorr,
											    null,
											    vrc_ds_ocorrencia,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    null,
											    vcr_noapolice,
											    vrc_retorno,
											    vrc_msg);

							if	vrc_msg	is	not	null	then
								--
								p_mens	:=	'SINI7070_008.prc_email_rc_ambiental - Erro durante a execuo' ||vrc_msg;
								raise	v_saida_anormal;
								--
							end	if;
							--
						exception
							--
							when	others	then
								--
								p_mens	:=	'SINI7070_008.prc_email_rc_ambiental - Erro geral: ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
								raise	v_saida_anormal;
								--
						end;
						--
					end	if;
					--
				end;
				--
				begin
					update	sinistro_relatorios	a
					set	a.id_extracao	=	'S',
						a.dt_extracao	=	sysdate
					where	a.cd_aviso	=	r0.cd_aviso;
					--
					commit;
					--
				exception
					when	others	then
						--
						p_mens	:=	'Erro ao tentar atualizar SINISTRO_RELATORIOS: ' ||DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
						raise	v_saida_anormal;
						--
				end;
				--
			exception
				when	v_saida_anormal	then
					--
					sini6002_117	('SINI7070_008'
							,p_mens
							,r0.cd_aviso
							,r0.nr_sinistro
							,null
							,null
							,v_mens_log_erro
							);
					--
					commit;
					--
				when	others		then
					--
					p_mens	:=	p_mens||' - '||DBMS_UTILITY.FORMAT_ERROR_STACK||' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
					sini6002_117	('SINI7070_008'
							,p_mens
							,r0.cd_aviso
							,r0.nr_sinistro
							,null
							,null
							,v_mens_log_erro
							);
					--
					commit;
					--
			end;
			--
		end	loop;
		--
		DBMS_OUTPUT.enable;
	end;
	--
begin
	-- global_cd_cia_seguradora := fnc_cia_seguradora();
	global_cd_cia_seguradora := 6190;
end sini7070_008;
