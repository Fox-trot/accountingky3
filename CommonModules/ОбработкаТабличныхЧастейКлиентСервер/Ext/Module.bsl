﻿#Область ПрограммныйИнтерфейс

// Рассчитывает сумму и базу в строке табличной части документа при поступлении
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//
Процедура РассчитатьСуммуИБазуНДССтрокиТабличнойЧастиПоступление(СтрокаТабличнойЧасти, ПараметрыРасчета) Экспорт
	
	Если ПараметрыРасчета.СуммаВключаетНалоги Тогда 
		СтрокаТабличнойЧасти.Сумма = (СтрокаТабличнойЧасти.Всего * ПараметрыРасчета.КурсДокумента 
										/ ПараметрыРасчета.КратностьДокумента) + СтрокаТабличнойЧасти.СуммаАкциза;	
	Иначе 
		СтрокаТабличнойЧасти.Сумма = (СтрокаТабличнойЧасти.Всего * ПараметрыРасчета.КурсДокумента 
										/ ПараметрыРасчета.КратностьДокумента) * 100 
										/ (100 + ПараметрыРасчета.ЗначениеСтавкиНДС + ПараметрыРасчета.ЗначениеСтавкиНСП);
	КонецЕсли;	
	
	Если ПараметрыРасчета.РассчитатьБазуНДС Тогда
		СтрокаТабличнойЧасти.БазаНДС = СтрокаТабличнойЧасти.Всего * ПараметрыРасчета.КурсНБКР / ПараметрыРасчета.КратностьНБКР;	
	КонецЕсли;	
КонецПроцедуры

// Расчет, исходя из постоянной суммы
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа.
//
Процедура РассчитатьСуммуНДССтрокиТабличнойЧастиПоступление(СтрокаТабличнойЧасти, ПараметрыРасчета) Экспорт
	
	СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДСПоступления(
		((СтрокаТабличнойЧасти.Всего * ПараметрыРасчета.КурсДокумента / ПараметрыРасчета.КратностьДокумента) 
			+ СтрокаТабличнойЧасти.СуммаАкциза),
		ПараметрыРасчета.СуммаВключаетНалоги,
		ПараметрыРасчета.ЗначениеСтавкиНДС,
		ПараметрыРасчета.ЗначениеСтавкиНСП);
		
КонецПроцедуры

// Расчет, исходя из постоянной суммы
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа.
//
Процедура РассчитатьСуммуНСПСтрокиТабличнойЧастиПоступление(СтрокаТабличнойЧасти, ПараметрыРасчета) Экспорт
	
	Если ПараметрыРасчета.БезналичныйРасчет Тогда
		СтрокаТабличнойЧасти.СуммаНСП = 0;
	Иначе
		Если ПараметрыРасчета.СуммаВключаетНалоги Тогда
			СтрокаТабличнойЧасти.СуммаНСП = ((СтрокаТабличнойЧасти.Всего * ПараметрыРасчета.КурсДокумента 
												/ ПараметрыРасчета.КратностьДокумента) + СтрокаТабличнойЧасти.СуммаАкциза) 
												* ПараметрыРасчета.ЗначениеСтавкиНСП / 100;
		Иначе
			СтрокаТабличнойЧасти.СуммаНСП = ((СтрокаТабличнойЧасти.Всего * ПараметрыРасчета.КурсДокумента 
												/ ПараметрыРасчета.КратностьДокумента) + СтрокаТабличнойЧасти.СуммаАкциза) 
												- СтрокаТабличнойЧасти.Сумма - СтрокаТабличнойЧасти.СуммаНДС;	 
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

// Рассчитывает сумму налогов в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти 	- Структура или СтрокаТабличнойЧасти - Строка табличной части документа.
//  Период					- Дата - Период расчета
//  СуммаВключаетНалоги	 	- Булево - Признак расчета суммы НДС и НСП
//  ЗначениеСтавкиНДС		- Число - Числовое значение ставки (15,2)
//  ЗначениеСтавкиНСП		- Число - Числовое значение ставки (15,2)
//  БезналичныйРасчет	 	- Булево - Признак безналичного расчета
//
Процедура РассчитатьСуммыНалоговСтрокиТабличнойЧастиПоступление(СтрокаТабличнойЧасти, ПараметрыРасчета) Экспорт

	Если ПараметрыРасчета.РассчитатьОтБазыНДС Тогда
		СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДСПоступления(
			(СтрокаТабличнойЧасти.БазаНДС + СтрокаТабличнойЧасти.СуммаАкциза),
			ПараметрыРасчета.СуммаВключаетНалоги,
			ПараметрыРасчета.ЗначениеСтавкиНДС,
			ПараметрыРасчета.ЗначениеСтавкиНСП);	
	Иначе	
		СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДСПоступления(
			((СтрокаТабличнойЧасти.Всего * ПараметрыРасчета.КурсДокумента / ПараметрыРасчета.КратностьДокумента) 
				+ СтрокаТабличнойЧасти.СуммаАкциза),
			ПараметрыРасчета.СуммаВключаетНалоги,
			ПараметрыРасчета.ЗначениеСтавкиНДС,
			ПараметрыРасчета.ЗначениеСтавкиНСП);
	КонецЕсли;
		
	Если ПараметрыРасчета.БезналичныйРасчет Тогда
		СтрокаТабличнойЧасти.СуммаНСП = 0;
	Иначе
		Если ПараметрыРасчета.СуммаВключаетНалоги Тогда
			СтрокаТабличнойЧасти.СуммаНСП = ((СтрокаТабличнойЧасти.Всего * ПараметрыРасчета.КурсДокумента 
												/ ПараметрыРасчета.КратностьДокумента) + СтрокаТабличнойЧасти.СуммаАкциза) 
												* ПараметрыРасчета.ЗначениеСтавкиНСП / 100;
		Иначе
			СтрокаТабличнойЧасти.СуммаНСП = ((СтрокаТабличнойЧасти.Всего * ПараметрыРасчета.КурсДокумента 
												/ ПараметрыРасчета.КратностьДокумента) + СтрокаТабличнойЧасти.СуммаАкциза) 
												- СтрокаТабличнойЧасти.Сумма - СтрокаТабличнойЧасти.СуммаНДС;	 
		КонецЕсли;
	КонецЕсли;	
		
КонецПроцедуры

// Выполняем пересчет налогов табличной части документа после изменений в форме
//  "Цены и валюта".
//
// Параметры:
//  Объект					- Объект - Объект пересчета
//  Период					- Дата - Период пересчета
//  ИмяТабличнойЧасти 		- Строка - Имя табличной части, в которой нужно пересчитать
//  СуммаВключаетНалоги	 	- Булево - Признак расчета суммы НДС и НСП
//  ЗначениеСтавкиНДС		- Число - Числовое значение ставки (15,2)
//  ЗначениеСтавкиНСП		- Число - Числовое значение ставки (15,2)
//  БезналичныйРасчет	 	- Булево - Признак безналичного расчета
//
Процедура ПересчитатьНалогиТабличнойЧастиПоступление(Объект, ИмяТабличнойЧасти, ПараметрыРасчета) Экспорт
	 
	Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл		
		// Расчет суммы
		РассчитатьСуммуИБазуНДССтрокиТабличнойЧастиПоступление(СтрокаТабличнойЧасти, ПараметрыРасчета);
			
		// Расчет налогов	
		РассчитатьСуммыНалоговСтрокиТабличнойЧастиПоступление(СтрокаТабличнойЧасти, ПараметрыРасчета);
	КонецЦикла;		
КонецПроцедуры 

//////////////////////////////////////////////////

// Рассчитывает количество в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//
Процедура РассчитатьКоличествоСтрокиТабличнойЧасти(СтрокаТабличнойЧасти) Экспорт

	СтрокаТабличнойЧасти.Количество = Окр(СтрокаТабличнойЧасти.КоличествоДопЕдиницы * СтрокаТабличнойЧасти.КоэффициентДопЕдиницы, 3);
	
КонецПроцедуры

// Рассчитывает сумму в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//
Процедура РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ПараметрыРасчета = Неопределено) Экспорт

	Если ПараметрыРасчета <> Неопределено Тогда
		ЗначениеСтавкиНДС = ?(ЗначениеЗаполнено(ПараметрыРасчета.СтавкаНДС), 
			УчетНДСВызовСервера.ПолучитьСтавкуНДС(ПараметрыРасчета.Период, ПараметрыРасчета.СтавкаНДС), 0);
			
		ЗначениеСтавкиНСП = ?(ПараметрыРасчета.БезналичныйРасчет Или НЕ ЗначениеЗаполнено(ПараметрыРасчета.СтавкаНСП), 0, 
			УчетНДСВызовСервера.ПолучитьСтавкуНСП(ПараметрыРасчета.Период, ПараметрыРасчета.Организация, ПараметрыРасчета.СтавкаНСП));
			
		СуммаНДС = Окр(СтрокаТабличнойЧасти.СуммаДохода * ЗначениеСтавкиНДС / 100, 2);	
		СуммаНСП = Окр(СтрокаТабличнойЧасти.СуммаДохода * ЗначениеСтавкиНСП / 100, 2);
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.СуммаДохода + СуммаНДС + СуммаНСП;
		
	ИначеЕсли СтрокаТабличнойЧасти.Свойство("Цена") Тогда 
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.Количество;
	КонецЕсли;	
КонецПроцедуры

// Рассчитывает цену в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//  ЗначениеПустогоКоличества - число - значение для в случае пустого количества
//  ПризнакСтраныЕАЭС - булево - признак, что страна входит в ЕАЭС
//  СчитатьОтДохода - булево - признак, что расчет идет от суммы дохода
//  Точность - число - точность округления цены
//
Процедура РассчитатьЦенуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ПараметрыРасчета = Неопределено, Точность = 2) Экспорт

	Если СтрокаТабличнойЧасти.Количество = 0 Тогда
		СтрокаТабличнойЧасти.Цена = 0;
		
	// Параметры ПризнакСтраныЕАЭС и ПризнакСтраныИмпортЭкспорт используются только для документов "Поступление товаров и услуг"
	// и "Возврат поставщику". Это необходимо для того, чтобы цена расчитывалась в валюте, а не в сомах, если валюта
	// в документе не сом.
	ИначеЕсли НЕ ПараметрыРасчета = Неопределено 
		И (ПараметрыРасчета.ПризнакСтраныЕАЭС ИЛИ ПараметрыРасчета.ПризнакСтраныИмпортЭкспорт) Тогда
		СтрокаТабличнойЧасти.Цена = Окр(СтрокаТабличнойЧасти.Всего / СтрокаТабличнойЧасти.Количество, ПараметрыРасчета.Точность);
		
	ИначеЕсли НЕ ПараметрыРасчета = Неопределено 
		И ПараметрыРасчета.СчитатьОтДохода Тогда
		СтрокаТабличнойЧасти.Цена = Окр(СтрокаТабличнойЧасти.СуммаДохода / СтрокаТабличнойЧасти.Количество, ПараметрыРасчета.Точность);
		
	Иначе
		СтрокаТабличнойЧасти.Цена = Окр(СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество, Точность);
	КонецЕсли; 
КонецПроцедуры

// Рассчитывает сумму налогов в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти 	- Структура или СтрокаТабличнойЧасти - Строка табличной части документа.
//  Период					- Дата - Период расчета
//  Организация			 	- СправочникСсылка.Организации - Ссылка на справочник Организации для ставки НСП
//  СуммаВключаетНалоги	 	- Булево - Признак расчета суммы НДС и НСП
//  СтавкаНДС			 	- СправочникСсылка.СтавкиНДС - Ссылка на справочник ставки НДС для расчета
//  СтавкаНСП			 	- СправочникСсылка.СтавкиНСП - Ссылка на справочник ставки НСП для расчета
//  БезналичныйРасчет	 	- Булево - Признак безналичного расчета
//
Процедура РассчитатьСуммыНалоговСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ПараметрыРасчета) Экспорт

	СчитатьСкидкуОтдельно = ?(ПараметрыРасчета.Свойство("СчитатьСкидкуОтдельно"), ПараметрыРасчета.СчитатьСкидкуОтдельно, Ложь);
	
	Если ТипЗнч(СтрокаТабличнойЧасти) = Тип("Структура") Тогда
		Если СтрокаТабличнойЧасти.Свойство("Сумма") 
			И СтрокаТабличнойЧасти.Свойство("СтавкаНДС")
			И СтрокаТабличнойЧасти.Свойство("СтавкаНСП") Тогда
			
			ЗначениеСтавкиНДС = ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС), 
									УчетНДСВызовСервера.ПолучитьСтавкуНДС(ПараметрыРасчета.Период, СтрокаТабличнойЧасти.СтавкаНДС), 0);
			ЗначениеСтавкиНСП = ?(ПараметрыРасчета.БезналичныйРасчет Или НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНСП), 0, 
									УчетНДСВызовСервера.ПолучитьСтавкуНСП(ПараметрыРасчета.Период, 
																			ПараметрыРасчета.Организация, 
																			СтрокаТабличнойЧасти.СтавкаНСП));
																			
			Если СчитатьСкидкуОтдельно Тогда
				Если СтрокаТабличнойЧасти.Свойство("СуммаСкидки") И  СтрокаТабличнойЧасти.СуммаСкидки <> 0 Тогда
					СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
												СтрокаТабличнойЧасти.СуммаСкидки,
												ПараметрыРасчета.СуммаВключаетНалоги,
												ЗначениеСтавкиНДС,
												ЗначениеСтавкиНСП);
														
					СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
												СтрокаТабличнойЧасти.СуммаСкидки,
												ПараметрыРасчета.СуммаВключаетНалоги,
												ЗначениеСтавкиНДС,
												ЗначениеСтавкиНСП);
												
					СтрокаТабличнойЧасти.СуммаНДССкидки = Окр(СуммаНДС, 2);
					СтрокаТабличнойЧасти.СуммаНСПСкидки = Окр(СуммаНСП, 2);
					
				ИначеЕсли СтрокаТабличнойЧасти.Свойство("СуммаСкидки") И  СтрокаТабличнойЧасти.СуммаСкидки = 0 Тогда
					СтрокаТабличнойЧасти.СуммаНДССкидки = 0;
					СтрокаТабличнойЧасти.СуммаНСПСкидки = 0;
				КонецЕсли;									
				
				СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
											СтрокаТабличнойЧасти.Сумма,
											ПараметрыРасчета.СуммаВключаетНалоги,
											ЗначениеСтавкиНДС,
											ЗначениеСтавкиНСП);
													
				СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
											СтрокаТабличнойЧасти.Сумма,
											ПараметрыРасчета.СуммаВключаетНалоги,
											ЗначениеСтавкиНДС,
											ЗначениеСтавкиНСП);
													
				СтрокаТабличнойЧасти.СуммаНДС = Окр(СуммаНДС, 2) - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаНДССкидки, 0);
				СтрокаТабличнойЧасти.СуммаНСП = Окр(СуммаНСП, 2) - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаНСПСкидки, 0);	
				
			Иначе
				СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
										СтрокаТабличнойЧасти.Сумма - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0),
										ПараметрыРасчета.СуммаВключаетНалоги,
										ЗначениеСтавкиНДС,
										ЗначениеСтавкиНСП);												
													
				СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
										СтрокаТабличнойЧасти.Сумма - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0),
										ПараметрыРасчета.СуммаВключаетНалоги,
										ЗначениеСтавкиНДС,
										ЗначениеСтавкиНСП);
													
				СтрокаТабличнойЧасти.СуммаНДС = Окр(СуммаНДС, 2);
				СтрокаТабличнойЧасти.СуммаНСП = Окр(СуммаНСП, 2);	
			КонецЕсли;	
		КонецЕсли;
		
	Иначе 		
		ЗначениеСтавкиНДС = ?(ЗначениеЗаполнено(ПараметрыРасчета.СтавкаНДС), 
								УчетНДСВызовСервера.ПолучитьСтавкуНДС(ПараметрыРасчета.Период, ПараметрыРасчета.СтавкаНДС), 0);
		ЗначениеСтавкиНСП = ?(ПараметрыРасчета.БезналичныйРасчет Или НЕ ЗначениеЗаполнено(ПараметрыРасчета.СтавкаНСП), 0, 
								УчетНДСВызовСервера.ПолучитьСтавкуНСП(ПараметрыРасчета.Период, 
																		ПараметрыРасчета.Организация, 
																		ПараметрыРасчета.СтавкаНСП));
																		
		Если СчитатьСкидкуОтдельно Тогда																		
			Если СтрокаТабличнойЧасти.Свойство("СуммаСкидки") И  СтрокаТабличнойЧасти.СуммаСкидки <> 0 Тогда
				СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
											СтрокаТабличнойЧасти.СуммаСкидки,
											ПараметрыРасчета.СуммаВключаетНалоги,
											ЗначениеСтавкиНДС,
											ЗначениеСтавкиНСП);
													
				СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
											СтрокаТабличнойЧасти.СуммаСкидки,
											ПараметрыРасчета.СуммаВключаетНалоги,
											ЗначениеСтавкиНДС,
											ЗначениеСтавкиНСП);
											
				СтрокаТабличнойЧасти.СуммаНДССкидки = Окр(СуммаНДС, 2);
				СтрокаТабличнойЧасти.СуммаНСПСкидки = Окр(СуммаНСП, 2);
				
			ИначеЕсли СтрокаТабличнойЧасти.Свойство("СуммаСкидки") И  СтрокаТабличнойЧасти.СуммаСкидки = 0 Тогда
					СтрокаТабличнойЧасти.СуммаНДССкидки = 0;
					СтрокаТабличнойЧасти.СуммаНСПСкидки = 0;
			КонецЕсли;									
			
			СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
										СтрокаТабличнойЧасти.Сумма,
										ПараметрыРасчета.СуммаВключаетНалоги,
										ЗначениеСтавкиНДС,
										ЗначениеСтавкиНСП);
												
			СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
										СтрокаТабличнойЧасти.Сумма,
										ПараметрыРасчета.СуммаВключаетНалоги,
										ЗначениеСтавкиНДС,
										ЗначениеСтавкиНСП);
												
			СтрокаТабличнойЧасти.СуммаНДС = Окр(СуммаНДС, 2) - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаНДССкидки, 0);
			СтрокаТабличнойЧасти.СуммаНСП = Окр(СуммаНСП, 2) - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаНСПСкидки, 0);	
			
		Иначе
			СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
										СтрокаТабличнойЧасти.Сумма - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0),
										ПараметрыРасчета.СуммаВключаетНалоги,
										ЗначениеСтавкиНДС,
										ЗначениеСтавкиНСП);
												
			СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
										СтрокаТабличнойЧасти.Сумма - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0),
										ПараметрыРасчета.СуммаВключаетНалоги,
										ЗначениеСтавкиНДС,
										ЗначениеСтавкиНСП);
												
			СтрокаТабличнойЧасти.СуммаНДС = Окр(СуммаНДС, 2);
			СтрокаТабличнойЧасти.СуммаНСП = Окр(СуммаНСП, 2);	
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

// Рассчитывает всего в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти 	- Структура или СтрокаТабличнойЧасти - Строка табличной части документа.
//  СуммаВключаетНалоги	 	- Булево - Признак расчета суммы НДС и НСП
//
Процедура РассчитатьВсегоСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, СуммаВключаетНалоги = Ложь) Экспорт

	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(СуммаВключаетНалоги, 
									СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП, 
									0);
	
КонецПроцедуры

// Рассчитывает сумму скидки в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - СтрокаТабличнойЧасти - Строка табличной части документа.
//
Процедура РассчитатьСкидкуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти) Экспорт

	СтрокаТабличнойЧасти.СуммаСкидки = Окр(СтрокаТабличнойЧасти.Сумма / 100 * СтрокаТабличнойЧасти.ПроцентСкидкиНаценки, 2);
		
КонецПроцедуры

// Рассчитывает сумму дохода в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти 	- Структура или СтрокаТабличнойЧасти - Строка табличной части документа.
//  СуммаВключаетНалоги	 	- Булево - Признак расчета суммы НДС и НСП
//
Процедура РассчитатьДоходСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, СуммаВключаетНалоги) Экспорт

	Если СуммаВключаетНалоги Тогда
		СтрокаТабличнойЧасти.СуммаДохода = Окр(СтрокаТабличнойЧасти.Всего - СтрокаТабличнойЧасти.СуммаНДС - СтрокаТабличнойЧасти.СуммаНСП
											- ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0), 2);
	Иначе
		СтрокаТабличнойЧасти.СуммаДохода = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена;
	КонецЕсли;	
КонецПроцедуры

// Рассчитывает сумму дохода скидки в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти 	- Структура или СтрокаТабличнойЧасти - Строка табличной части документа.
//
Процедура РассчитатьДоходСкидкиСтрокиТабличнойЧасти(СтрокаТабличнойЧасти) Экспорт

	СтрокаТабличнойЧасти.СуммаДоходаСкидки = СтрокаТабличнойЧасти.СуммаСкидки - СтрокаТабличнойЧасти.СуммаНДССкидки - СтрокаТабличнойЧасти.СуммаНСПСкидки;	
	
КонецПроцедуры


//// Расчет, исходя из постоянной суммы
////
//// Параметры:
////  СтрокаТабличнойЧасти - строка табличной части документа.
////
//Процедура РассчитатьСуммуНДССтрокиТабличнойЧасти(СтрокаТабличнойЧасти, Период, Организация, СуммаВключаетНалоги = Ложь, СтавкаНДС = Неопределено, СтавкаНСП = Неопределено, БезналичныйРасчет = Ложь) Экспорт

//	Если ТипЗнч(СтрокаТабличнойЧасти)=Тип("Структура") Тогда
//		Если СтрокаТабличнойЧасти.Свойство("Сумма") 
//			И СтрокаТабличнойЧасти.Свойство("СтавкаНДС")
//			И СтрокаТабличнойЧасти.Свойство("СтавкаНСП") Тогда
//			СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
//				СтрокаТабличнойЧасти.Сумма,
//				СуммаВключаетНалоги,
//				?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС), УчетНДСВызовСервера.ПолучитьСтавкуНДС(Период, СтрокаТабличнойЧасти.СтавкаНДС), 0),
//				?(БезналичныйРасчет Или НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНСП), 0, УчетНДСВызовСервера.ПолучитьСтавкуНСП(Период, Организация, СтрокаТабличнойЧасти.СтавкаНСП)));
//		КонецЕсли;
//	Иначе // Строка табличной части
//		СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
//			СтрокаТабличнойЧасти.Сумма,
//			СуммаВключаетНалоги,
//			?(ЗначениеЗаполнено(СтавкаНДС), УчетНДСВызовСервера.ПолучитьСтавкуНДС(Период, СтавкаНДС), 0),
//			?(БезналичныйРасчет Или НЕ ЗначениеЗаполнено(СтавкаНСП), 0, УчетНДСВызовСервера.ПолучитьСтавкуНСП(Период, Организация, СтавкаНСП)));
//	КонецЕсли;
//		
//	Если СтрокаТабличнойЧасти.Свойство("Всего") Тогда
//		СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);
//	КонецЕсли;	
//КонецПроцедуры

// Расчет, исходя из постоянной суммы
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа.
//
Процедура РассчитатьСуммуНСПСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ПараметрыРасчета) Экспорт
	
	Если ТипЗнч(СтрокаТабличнойЧасти) = Тип("Структура") Тогда
		Если СтрокаТабличнойЧасти.Свойство("Сумма") 
			И СтрокаТабличнойЧасти.Свойство("ЗначениеСтавкаНДС")
			И СтрокаТабличнойЧасти.Свойство("ЗначениеСтавкаНСП") Тогда
			СтрокаТабличнойЧасти.СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
				СтрокаТабличнойЧасти.Сумма,
				ПараметрыРасчета.СуммаВключаетНалоги,
				СтрокаТабличнойЧасти.ЗначениеСтавкаНДС,
				?(ПараметрыРасчета.БезналичныйРасчет, 0 ,СтрокаТабличнойЧасти.ЗначениеСтавкаНСП));
		КонецЕсли;
			
	Иначе // Строка табличной части
		СтрокаТабличнойЧасти.СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
			СтрокаТабличнойЧасти.Сумма,
			ПараметрыРасчета.СуммаВключаетНалоги,
			СтрокаТабличнойЧасти.ЗначениеСтавкаНДС,
			?(ПараметрыРасчета.БезналичныйРасчет, 0 ,СтрокаТабличнойЧасти.ЗначениеСтавкаНСП));
	КонецЕсли;

	Если СтрокаТабличнойЧасти.Свойство("Всего") Тогда
		СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(ПараметрыРасчета.СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);
	КонецЕсли;	
КонецПроцедуры

// Процедура выполняет стандартные действия по расчету плановой суммы
// в строке табличной части документа.
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа,
//
Процедура ПересчитатьПлановуюСумму(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	СтрокаТабличнойЧасти.СуммаПлановая = 
		?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество)
		* СтрокаТабличнойЧасти.ПлановаяСтоимость;

КонецПроцедуры

// Выполняем пересчет цены по валюте табличной части документа после изменений в форме
//  "Цены и валюта".
//
// Параметры:
//  Объект				- Объект - Объект пересчета
//  Период				- Дата - Период пересчета
//  СтруктураКурсыПред - Структура - Параметры курса.
//       * Курс      - Число - Курс валюты на указанную дату.
//       * Кратность - Число - Кратность валюты на указанную дату.
//       * Валюта    - СправочникСсылка.Валюты - Ссылка валюты.
// 	СтруктураКурсы - Структура - Параметры курса.
//       * Курс      - Число - Курс валюты на указанную дату.
//       * Кратность - Число - Кратность валюты на указанную дату.
//       * Валюта    - СправочникСсылка.Валюты - Ссылка валюты.
//  ИмяТабличнойЧасти 	- Строка - Имя табличной части, в которой нужно пересчитать
//  Точность - число - точность округления цены
//
Процедура ПересчитатьЦеныТабличнойЧастиПоВалюте(Объект, Период, СтруктураКурсыПред, СтруктураКурсы, ИмяТабличнойЧасти, Точность = 2) Экспорт
	
	Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл
		// Цена.
		Если СтрокаТабличнойЧасти.Свойство("Цена") Тогда
			СтрокаТабличнойЧасти.Цена = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(СтрокаТабличнойЧасти.Цена, 
				Новый Структура("Валюта, Курс, Кратность", СтруктураКурсыПред.Валюта, СтруктураКурсыПред.Курс, СтруктураКурсыПред.Кратность),
				Новый Структура("Валюта, Курс, Кратность", СтруктураКурсы.Валюта, СтруктураКурсы.Курс, СтруктураКурсы.Кратность));
		КонецЕсли;
	КонецЦикла;		
КонецПроцедуры // ПересчитатьЦеныТабличнойЧастиПоВалюте()

// Выполняем пересчет налогов табличной части документа после изменений в форме
//  "Цены и валюта".
//
// Параметры:
//  Объект					- Объект - Объект пересчета
//  Период					- Дата - Период пересчета
//  Организация			 	- СправочникСсылка.Организации - Ссылка на справочник Организации для Ставки НСП
//  ИмяТабличнойЧасти 		- Строка - Имя табличной части, в которой нужно пересчитать
//  СуммаВключаетНалоги	 	- Булево - Признак расчета суммы НДС и НСП
//  СтавкаНДС			 	- СправочникСсылка.СтавкиНДС - Ссылка на справочник ставки НДС для пересчета
//  СтавкаНСП			 	- СправочникСсылка.СтавкиНСП - Ссылка на справочник ставки НСП для пересчета
//  БезналичныйРасчет	 	- Булево - Признак безналичного расчета
//
Процедура ПересчитатьНалогиТабличнойЧасти(Объект, ПараметрыРасчета) Экспорт
	
	ЗначениеСтавкиНДС = ?(ЗначениеЗаполнено(ПараметрыРасчета.СтавкаНДС), 
							УчетНДСВызовСервера.ПолучитьСтавкуНДС(ПараметрыРасчета.Период, ПараметрыРасчета.СтавкаНДС), 0);
	ЗначениеСтавкиНСП = ?(ПараметрыРасчета.БезналичныйРасчет Или НЕ ЗначениеЗаполнено(ПараметрыРасчета.СтавкаНСП), 0, 
							УчетНДСВызовСервера.ПолучитьСтавкуНСП(ПараметрыРасчета.Период, 
																	ПараметрыРасчета.Организация, 
																	ПараметрыРасчета.СтавкаНСП));

	Для Каждого СтрокаТабличнойЧасти Из Объект[ПараметрыРасчета.ИмяТабличнойЧасти] Цикл
		// СуммаНДС.
		СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
			?(ПараметрыРасчета.СчитатьОтДохода, СтрокаТабличнойЧасти.СуммаДохода, 
				СтрокаТабличнойЧасти.Сумма - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0)),
			ПараметрыРасчета.СуммаВключаетНалоги,           
			ЗначениеСтавкиНДС,
			ЗначениеСтавкиНСП);
			
		// СуммаНСП.
		СтрокаТабличнойЧасти.СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
			?(ПараметрыРасчета.СчитатьОтДохода, СтрокаТабличнойЧасти.СуммаДохода, 
				СтрокаТабличнойЧасти.Сумма - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0)),
			ПараметрыРасчета.СуммаВключаетНалоги,
			ЗначениеСтавкиНДС,
			ЗначениеСтавкиНСП);
			
		Если СтрокаТабличнойЧасти.Свойство("Всего") Тогда
			СтрокаТабличнойЧасти.Всего = ?(ПараметрыРасчета.СчитатьОтДохода, СтрокаТабличнойЧасти.СуммаДохода, СтрокаТабличнойЧасти.Сумма) 
									+ ?(ПараметрыРасчета.СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);
		КонецЕсли;
		
		Если СтрокаТабличнойЧасти.Свойство("СуммаДохода") И НЕ ПараметрыРасчета.СчитатьОтДохода Тогда
			СтрокаТабличнойЧасти.СуммаДохода = СтрокаТабличнойЧасти.Всего 
												- СтрокаТабличнойЧасти.СуммаНДС 
												- СтрокаТабличнойЧасти.СуммаНСП
												- ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0);
		КонецЕсли;
	КонецЦикла;		

КонецПроцедуры // ПересчитатьЦеныТабличнойЧастиПоВалюте()

// Функция выполняет поиск первой, удовлетворяющей условию поиска, строки табличной части.
//
// Параметры:
//  ИмяТабличнойЧасти - Строка - Имя табличной части документа, в которой осуществляется поиск,
//  СтруктураОтбора - Структура - задает условие поиска.
//
// Возвращаемое значение: 
//  Строка табличной части - найденная строка табличной части,
//  Неопределено           - строка табличной части не найдена.
//
Функция НайтиСтрокуТабличнойЧасти(Объект, ИмяТабличнойЧасти, СтруктураОтбора) Экспорт

	СтрокаТабличнойЧасти = Неопределено;
	МассивНайденныхСтрок = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда

		// Нашли. Вернем первую найденную строку.
		СтрокаТабличнойЧасти = МассивНайденныхСтрок[0];
	КонецЕсли;

	Возврат СтрокаТабличнойЧасти;

КонецФункции

// Рассчитывает сумму взаиморасчетов в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти	- СтрокаТабличнойЧасти	 - строка табличной части документа
//  ДанныеДокумента			- Структура - Данные документа
//		* Валюта	- СправочникСсылка.Валюты - Валюта документа
//		* Курс		- Число - Курс документа
//		* Кратность - Число - Кратность документа
//		* ПрямойКурс - Булево - признак расчета курса (всегда рассчитывается отношение большего курса к меньшему)
//  ДанныеВзаиморасчетов	- Структура - Данные взаиморасчетов
//		* Валюта	- СправочникСсылка.Валюты - Валюта расчетов
//		* Курс		- Число - Курс расчетов
//		* Кратность - Число - Кратность документа
//  ВалютаРегламентированногоУчета	 - СправочникСсылка.Валюты - Валюта регламентированного учета
//
Процедура РассчитатьСуммуВзаиморасчетовСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеДокумента, ДанныеВзаиморасчетов, ВалютаРегламентированногоУчета) Экспорт

	// Валюта взаиморасчетов в валюте регламентированного учета. 
	Если ДанныеВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда 
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
			СтрокаТабличнойЧасти.СуммаПлатежа, 
			Новый Структура("Валюта, Курс, Кратность", ДанныеВзаиморасчетов.Валюта, ДанныеВзаиморасчетов.Курс, ДанныеВзаиморасчетов.Кратность),
			Новый Структура("Валюта, Курс, Кратность", ДанныеДокумента.Валюта, 1, 1));
			
	// В документа в валюте регламентированного учета.
	ИначеЕсли ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета Тогда  
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
			СтрокаТабличнойЧасти.СуммаПлатежа, 
			Новый Структура("Валюта, Курс, Кратность", ДанныеДокумента.Валюта, ДанныеДокумента.Курс, ДанныеДокумента.Кратность),
			Новый Структура("Валюта, Курс, Кратность", ДанныеВзаиморасчетов.Валюта, ДанныеВзаиморасчетов.Курс, ДанныеВзаиморасчетов.Кратность));
			
	// В любой другой валюте.
	Иначе		
		Если ДанныеДокумента.ПрямойКурс Тогда 
			СтрокаТабличнойЧасти.СуммаВзаиморасчетов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
				СтрокаТабличнойЧасти.СуммаПлатежа, 
				Новый Структура("Валюта, Курс, Кратность", ДанныеВзаиморасчетов.Валюта, ДанныеВзаиморасчетов.Курс, ДанныеВзаиморасчетов.Кратность),
				Новый Структура("Валюта, Курс, Кратность", ДанныеДокумента.Валюта, 1, 1));
		Иначе
			СтрокаТабличнойЧасти.СуммаВзаиморасчетов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
				СтрокаТабличнойЧасти.СуммаПлатежа,
				Новый Структура("Валюта, Курс, Кратность", ДанныеДокумента.Валюта, 1, 1),
				Новый Структура("Валюта, Курс, Кратность", ДанныеВзаиморасчетов.Валюта, ДанныеВзаиморасчетов.Курс, ДанныеВзаиморасчетов.Кратность));	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Рассчитывает курс взаиморасчетов в строке табличной части документа
//
// Параметры:
//  Объект					- Объект - Объект пересчета
//  СтрокаТабличнойЧасти	- СтрокаТабличнойЧасти	 - строка табличной части документа
//  ДанныеДокумента			- Структура - Данные документа
//		* Валюта	- СправочникСсылка.Валюты - Валюта документа
//		* Курс		- Число - Курс документа
//		* Кратность - Число - Кратность документа
//  ДанныеВзаиморасчетов	- Структура - Данные взаиморасчетов
//		* Валюта	- СправочникСсылка.Валюты - Валюта расчетов
//		* Курс		- Число - Курс расчетов
//		* Кратность - Число - Кратность документа
//  ВалютаРегламентированногоУчета	 - СправочникСсылка.Валюты - Валюта регламентированного учета
//
Процедура РассчитатьКурсВзаиморасчетовТабличнойЧасти(Объект, СтрокаТабличнойЧасти, ДанныеДокумента, ДанныеВзаиморасчетов, ВалютаРегламентированногоУчета) Экспорт
		
	Если СтрокаТабличнойЧасти.СуммаПлатежа = 0
		Или СтрокаТабличнойЧасти.СуммаВзаиморасчетов = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	// Валюта взаиморасчетов в валюте регламентированного учета. 
	Если ДанныеВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета ИЛИ ДанныеДокумента.ПрямойКурс Тогда
		Объект.КурсВзаиморасчетов = 
			Окр(СтрокаТабличнойЧасти.СуммаВзаиморасчетов * ДанныеДокумента.Кратность / (СтрокаТабличнойЧасти.СуммаПлатежа * ДанныеВзаиморасчетов.Кратность), 4);
	// В любой другой валюте.		
	Иначе		
		Объект.КурсВзаиморасчетов = 
			Окр(СтрокаТабличнойЧасти.СуммаПлатежа / (СтрокаТабличнойЧасти.СуммаВзаиморасчетов / ДанныеВзаиморасчетов.Кратность), 4);
	КонецЕсли;	

КонецПроцедуры

// Процедура устанавливает курсы валют табличной части документа
// Если валюты разные, то курс взаиморасчетов равен отношению большего курса на меньший.
//
// Параметры:
//  Объект					- Объект - Объект пересчета
//  ИмяТабличнойЧасти 		- Строка - Имя табличной части, в которой нужно пересчитать
//  ДанныеДокумента			- Структура - Данные документа
//		* Валюта	- СправочникСсылка.Валюты - Валюта документа
//		* Курс		- Число - Курс документа
//		* Кратность - Число - Кратность документа
//  ДанныеВзаиморасчетов	- Структура - Данные взаиморасчетов
//		* Валюта	- СправочникСсылка.Валюты - Валюта расчетов
//		* Курс		- Число - Курс расчетов
//		* Кратность - Число - Кратность документа
//  ВалютаРегламентированногоУчета	 - СправочникСсылка.Валюты - Валюта регламентированного учета
//
Процедура УстановитьКурсыВзаиморасчетовТабличнойЧасти(Объект, ИмяТабличнойЧасти, ДанныеДокумента, ДанныеВзаиморасчетов, ВалютаРегламентированногоУчета) Экспорт
	
	Если ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И ДанныеВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда 
		Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс;
		Объект.КратностьВзаиморасчетов = ДанныеДокумента.Кратность;
	// 2. Валюта документа USD, валюта расчетов USD.
	ИначеЕсли НЕ ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И ДанныеВзаиморасчетов.Валюта = ДанныеДокумента.Валюта Тогда
		Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс;
		Объект.КратностьВзаиморасчетов = ДанныеДокумента.Кратность;
	// 3. Валюта документа KGS, валюта расчетов USD.
	ИначеЕсли ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И НЕ ДанныеВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда
		Объект.КурсВзаиморасчетов = ДанныеВзаиморасчетов.Курс;
		Объект.КратностьВзаиморасчетов = ДанныеВзаиморасчетов.Кратность;
		Объект.ПрямойКурс = Ложь;
	// 4. Валюта документа USD, валюта расчетов KGS.
	ИначеЕсли НЕ ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И ДанныеВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда
		Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс;
		Объект.КратностьВзаиморасчетов = ДанныеДокумента.Кратность;
		Объект.ПрямойКурс = Истина;
	// 5. Валюта документа USD, валюта расчетов RUB.
	ИначеЕсли НЕ ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И НЕ ДанныеВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда
		
		Если ДанныеДокумента.Курс >= ДанныеВзаиморасчетов.Курс 
			И ДанныеДокумента.Кратность >= ДанныеВзаиморасчетов.Кратность Тогда 
			Если ДанныеВзаиморасчетов.Курс * ДанныеДокумента.Кратность = 0 Тогда 
				Объект.КурсВзаиморасчетов = 0;
			Иначе 			
				Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс * ДанныеВзаиморасчетов.Кратность / ДанныеВзаиморасчетов.Курс * ДанныеДокумента.Кратность;
			КонецЕсли;
			
			Объект.КратностьВзаиморасчетов = 1;
			Объект.ПрямойКурс = Истина;
		Иначе
			Если ДанныеДокумента.Курс * ДанныеВзаиморасчетов.Кратность = 0 Тогда 
				Объект.КурсВзаиморасчетов = 0;
			Иначе 	
				Объект.КурсВзаиморасчетов = ДанныеВзаиморасчетов.Курс * ДанныеДокумента.Кратность / ДанныеДокумента.Курс * ДанныеВзаиморасчетов.Кратность;
			КонецЕсли;
			
			Объект.КратностьВзаиморасчетов = 1;
			Объект.ПрямойКурс = Ложь;
		КонецЕсли;	
	КонецЕсли;
	
	// Обновление данных структуры.
	ДанныеДокумента.ПрямойКурс = Объект.ПрямойКурс;
	ДанныеВзаиморасчетов.Курс = Объект.КурсВзаиморасчетов; 
	ДанныеВзаиморасчетов.Кратность = Объект.КратностьВзаиморасчетов; 	

КонецПроцедуры

// Рассчитывает сумму взаиморасчетов в табличной части документа
//
// Параметры:
//  Объект					- Объект - Объект пересчета
//  ИмяТабличнойЧасти 		- Строка - Имя табличной части, в которой нужно пересчитать
//  ДанныеДокумента			- Структура - Данные документа
//		* Валюта	- СправочникСсылка.Валюты - Валюта документа
//		* Курс		- Число - Курс документа
//		* Кратность - Число - Кратность документа
//  ДанныеВзаиморасчетов	- Структура - Данные взаиморасчетов
//		* Валюта	- СправочникСсылка.Валюты - Валюта расчетов
//		* Курс		- Число - Курс расчетов
//		* Кратность - Число - Кратность документа
//  ВалютаРегламентированногоУчета	 - СправочникСсылка.Валюты - Валюта регламентированного учета
//
Процедура РассчитатьСуммуВзаиморасчетовТабличнойЧасти(Объект, ИмяТабличнойЧасти, ДанныеДокумента, ДанныеВзаиморасчетов, ВалютаРегламентированногоУчета) Экспорт
	Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл 
		РассчитатьСуммуВзаиморасчетовСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеДокумента, ДанныеВзаиморасчетов, ВалютаРегламентированногоУчета);
	КонецЦикла;			
КонецПроцедуры

#Область Производство

// Процедура выполняет стандартные действия по расчету плановой суммы
// в строке табличной части документа.
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа,
//
Процедура РассчитатьПлановуюСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	СтрокаТабличнойЧасти.СуммаПлановая = 
		?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество)
		* СтрокаТабличнойЧасти.ПлановаяСтоимость;

КонецПроцедуры

// Рассчитывает цену в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//
Процедура РассчитатьПлановуюСтоимостьСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	РасчетноеКоличество = ?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество);
	
	Если РасчетноеКоличество = 0 Тогда
		СтрокаТабличнойЧасти.ПлановаяСтоимость = 0;
	Иначе
		СтрокаТабличнойЧасти.ПлановаяСтоимость = СтрокаТабличнойЧасти.СуммаПлановая / РасчетноеКоличество;
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#КонецОбласти



