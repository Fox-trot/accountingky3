﻿
// Рассчитывает сумму в строке табличной части документа при поступлении
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//
Процедура РассчитатьСуммуИБазуНДССтрокиТабличнойЧастиПоступление(
	СтрокаТабличнойЧасти, 
	СуммаВключаетНалоги = Ложь,
	ЗначениеСтавкиНДС = 0, 
	ЗначениеСтавкиНСП = 0, 
	БезналичныйРасчет = Ложь, 
	СуммаАкциза = 0, 
	Знач КурсДокумента = 1, 
	Знач КратностьДокумента = 1,
	Знач КурсНБКР = 1, 
	Знач КратностьНБКР = 1,
	РассчитатьБазуНДС = Ложь) Экспорт
	
	КратностьДокумента = ?(КратностьДокумента = 0, 1, КратностьДокумента);
	Если СуммаВключаетНалоги Тогда 
		СтрокаТабличнойЧасти.Сумма = (СтрокаТабличнойЧасти.Всего * КурсДокумента / КратностьДокумента) + СуммаАкциза;	
	Иначе 
		СтрокаТабличнойЧасти.Сумма = (СтрокаТабличнойЧасти.Всего * КурсДокумента / КратностьДокумента) * 100 / (100 + ЗначениеСтавкиНДС + ЗначениеСтавкиНСП);
	КонецЕсли;	
	
	Если РассчитатьБазуНДС Тогда
		СтрокаТабличнойЧасти.БазаНДС = СтрокаТабличнойЧасти.Всего * КурсНБКР / КратностьНБКР;	
	КонецЕсли;	
КонецПроцедуры

// Расчет, исходя из постоянной суммы
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа.
//
Процедура РассчитатьСуммуНДССтрокиТабличнойЧастиПоступление(
	СтрокаТабличнойЧасти, 
	СуммаВключаетНалоги = Ложь,
	ЗначениеСтавкиНДС = 0, 
	ЗначениеСтавкиНСП = 0, 
	БезналичныйРасчет = Ложь, 
	СуммаАкциза = 0,
	Знач КурсДокумента = 1, 
	Знач КратностьДокумента = 1) Экспорт
	
	КратностьДокумента = ?(КратностьДокумента = 0, 1, КратностьДокумента); 
	СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДСПоступления(
		((СтрокаТабличнойЧасти.Всего * КурсДокумента / КратностьДокумента) + СуммаАкциза),
		СуммаВключаетНалоги,
		ЗначениеСтавкиНДС,
		ЗначениеСтавкиНСП);
		
КонецПроцедуры

// Расчет, исходя из постоянной суммы
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа.
//
Процедура РассчитатьСуммуНСПСтрокиТабличнойЧастиПоступление(
	СтрокаТабличнойЧасти, 
	СуммаАкциза = 0,
	Знач КурсДокумента = 1, 
	Знач КратностьДокумента = 1) Экспорт
	
	КратностьДокумента = ?(КратностьДокумента = 0, 1, КратностьДокумента); 
	СтрокаТабличнойЧасти.СуммаНСП = ((СтрокаТабличнойЧасти.Всего * КурсДокумента / КратностьДокумента) + СуммаАкциза) - СтрокаТабличнойЧасти.Сумма - СтрокаТабличнойЧасти.СуммаНДС;
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
Процедура РассчитатьСуммыНалоговСтрокиТабличнойЧастиПоступление(
	СтрокаТабличнойЧасти, 
	СуммаВключаетНалоги = Ложь,
	ЗначениеСтавкиНДС = 0, 
	ЗначениеСтавкиНСП = 0, 
	БезналичныйРасчет = Ложь, 
	СуммаАкциза = 0,
	Знач КурсДокумента = 1, 
	Знач КратностьДокумента = 1,
	РассчитатьОтБазыНДС = Ложь) Экспорт

	КратностьДокумента = ?(КратностьДокумента = 0, 1, КратностьДокумента);
	
	Если РассчитатьОтБазыНДС Тогда
		СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДСПоступления(
			(СтрокаТабличнойЧасти.БазаНДС + СуммаАкциза),
			СуммаВключаетНалоги,
			ЗначениеСтавкиНДС,
			ЗначениеСтавкиНСП);	
	Иначе	
		СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДСПоступления(
			((СтрокаТабличнойЧасти.Всего * КурсДокумента / КратностьДокумента) + СуммаАкциза),
			СуммаВключаетНалоги,
			ЗначениеСтавкиНДС,
			ЗначениеСтавкиНСП);
	КонецЕсли;
		
	Если БезналичныйРасчет Тогда
		СтрокаТабличнойЧасти.СуммаНСП = 0;
	Иначе
		Если СуммаВключаетНалоги Тогда
			СтрокаТабличнойЧасти.СуммаНСП = ((СтрокаТабличнойЧасти.Всего * КурсДокумента / КратностьДокумента) + СуммаАкциза) * ЗначениеСтавкиНСП / 100;
		Иначе
			СтрокаТабличнойЧасти.СуммаНСП = ((СтрокаТабличнойЧасти.Всего * КурсДокумента / КратностьДокумента) + СуммаАкциза) - СтрокаТабличнойЧасти.Сумма - СтрокаТабличнойЧасти.СуммаНДС;	 
		КонецЕсли;
	КонецЕсли;	
		
КонецПроцедуры

// Выполняем пересчет налогов табличной части документа после изменений в форме
//  "Цены и валюта".
//
// Параметры:
//  Объект					- Объект - Объект пересчета
//  Период					- Дата - Период пересчета
//  ИмяТабличнойЧасти 		- Строка - Имя табличной части, в которой нужно переститать
//  СуммаВключаетНалоги	 	- Булево - Признак расчета суммы НДС и НСП
//  ЗначениеСтавкиНДС		- Число - Числовое значение ставки (15,2)
//  ЗначениеСтавкиНСП		- Число - Числовое значение ставки (15,2)
//  БезналичныйРасчет	 	- Булево - Признак безналичного расчета
//
Процедура ПересчитатьНалогиТабличнойЧастиПоступление(
	Объект, 
	ИмяТабличнойЧасти, 
	СуммаВключаетНалоги = Ложь,
	ЗначениеСтавкиНДС = 0, 
	ЗначениеСтавкиНСП = 0, 
	БезналичныйРасчет = Ложь,
	Знач КурсДокумента = 1, 
	Знач КратностьДокумента = 1,
	Знач КурсНБКР = 1, 
	Знач КратностьНБКР = 1,
	РассчитатьОтБазыНДС = Ложь) Экспорт
	
	КратностьДокумента = ?(КратностьДокумента = 0, 1, КратностьДокумента); 
	Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл
		СуммаАкциза = 0;
		Если СтрокаТабличнойЧасти.Свойство("СуммаАкциза") Тогда
			СуммаАкциза = СтрокаТабличнойЧасти.СуммаАкциза;
		КонецЕсли;	
		
		// Расчет суммы
		РассчитатьСуммуИБазуНДССтрокиТабличнойЧастиПоступление(
			СтрокаТабличнойЧасти, 
			СуммаВключаетНалоги,
			ЗначениеСтавкиНДС, 
			ЗначениеСтавкиНСП,
			БезналичныйРасчет,
			СуммаАкциза,
			КурсДокумента,
			КратностьДокумента,
			КурсНБКР,
			КратностьНБКР,
			РассчитатьОтБазыНДС);	
		// Расчет налогов	
		РассчитатьСуммыНалоговСтрокиТабличнойЧастиПоступление(
			СтрокаТабличнойЧасти, 
			СуммаВключаетНалоги,
			ЗначениеСтавкиНДС, 
			ЗначениеСтавкиНСП, 
			БезналичныйРасчет,
			СуммаАкциза,
			КурсДокумента,
			КратностьДокумента,
			РассчитатьОтБазыНДС);
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
Процедура РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0, СтруктураДопПараметров = Неопределено) Экспорт

	Если СтруктураДопПараметров <> Неопределено Тогда
		ЗначениеСтавкиНДС = ?(ЗначениеЗаполнено(СтруктураДопПараметров.СтавкаНДС), 
			УчетНДСВызовСервера.ПолучитьСтавкуНДС(СтруктураДопПараметров.Период, СтруктураДопПараметров.СтавкаНДС), 0);
			
		ЗначениеСтавкиНСП = ?(СтруктураДопПараметров.БезналичныйРасчет Или НЕ ЗначениеЗаполнено(СтруктураДопПараметров.СтавкаНСП), 0, 
			УчетНДСВызовСервера.ПолучитьСтавкуНСП(СтруктураДопПараметров.Период, СтруктураДопПараметров.Организация, СтруктураДопПараметров.СтавкаНСП));
		
		СтрокаТабличнойЧасти.Сумма = Окр(СтрокаТабличнойЧасти.СуммаДохода * (1 + ЗначениеСтавкиНДС / 100 + ЗначениеСтавкиНСП / 100), 2);
		
	ИначеЕсли СтрокаТабличнойЧасти.Свойство("Цена") Тогда 
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена * ?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество);
	КонецЕсли;	
КонецПроцедуры

// Рассчитывает цену в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//
Процедура РассчитатьЦенуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0, СтранаВходитВЕАЭС = Ложь, СчитатьОтДохода = Ложь) Экспорт

	Если СтранаВходитВЕАЭС Тогда	
		СтрокаТабличнойЧасти.Цена = ?(СтрокаТабличнойЧасти.Количество = 0, 0, СтрокаТабличнойЧасти.Всего / СтрокаТабличнойЧасти.Количество);
		
	Иначе	
		РасчетноеКоличество = ?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество);
		
		Если РасчетноеКоличество = 0 Тогда
			СтрокаТабличнойЧасти.Цена = 0;
			
		ИначеЕсли СчитатьОтДохода Тогда
			СтрокаТабличнойЧасти.Цена = Окр(СтрокаТабличнойЧасти.СуммаДохода / РасчетноеКоличество, 2);
			
		Иначе
			СтрокаТабличнойЧасти.Цена = Окр(СтрокаТабличнойЧасти.Сумма / РасчетноеКоличество, 2);
		КонецЕсли; 
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
Процедура РассчитатьСуммыНалоговСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, Период, Организация, СуммаВключаетНалоги = Ложь, СтавкаНДС = Неопределено, СтавкаНСП = Неопределено, БезналичныйРасчет = Ложь) Экспорт

	Если ТипЗнч(СтрокаТабличнойЧасти) = Тип("Структура") Тогда
		Если СтрокаТабличнойЧасти.Свойство("Сумма") 
			И СтрокаТабличнойЧасти.Свойство("СтавкаНДС")
			И СтрокаТабличнойЧасти.Свойство("СтавкаНСП") Тогда
			
			ЗначениеСтавкиНДС = ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС), УчетНДСВызовСервера.ПолучитьСтавкуНДС(Период, СтрокаТабличнойЧасти.СтавкаНДС), 0);
			ЗначениеСтавкиНСП = ?(БезналичныйРасчет Или НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНСП), 0, УчетНДСВызовСервера.ПолучитьСтавкуНСП(Период, Организация, СтрокаТабличнойЧасти.СтавкаНСП));
			
			СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
									СтрокаТабличнойЧасти.Сумма - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0),
									СуммаВключаетНалоги,
									ЗначениеСтавкиНДС,
									ЗначениеСтавкиНСП);												
												
			СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
									СтрокаТабличнойЧасти.Сумма - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0),
									СуммаВключаетНалоги,
									ЗначениеСтавкиНДС,
									ЗначениеСтавкиНСП);
												
			СтрокаТабличнойЧасти.СуммаНДС = Окр(СуммаНДС, 2);
			СтрокаТабличнойЧасти.СуммаНСП = Окр(СуммаНСП, 2);
		КонецЕсли;
		
	Иначе // Строка табличной части
		
		ЗначениеСтавкиНДС = ?(ЗначениеЗаполнено(СтавкаНДС), УчетНДСВызовСервера.ПолучитьСтавкуНДС(Период, СтавкаНДС), 0);
		ЗначениеСтавкиНСП = ?(БезналичныйРасчет Или НЕ ЗначениеЗаполнено(СтавкаНСП), 0, УчетНДСВызовСервера.ПолучитьСтавкуНСП(Период, Организация, СтавкаНСП));

		СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
									СтрокаТабличнойЧасти.Сумма - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0),
									СуммаВключаетНалоги,
									ЗначениеСтавкиНДС,
									ЗначениеСтавкиНСП);
											
		СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
									СтрокаТабличнойЧасти.Сумма - ?(СтрокаТабличнойЧасти.Свойство("СуммаСкидки"), СтрокаТабличнойЧасти.СуммаСкидки, 0),
									СуммаВключаетНалоги,
									ЗначениеСтавкиНДС,
									ЗначениеСтавкиНСП);
											
		СтрокаТабличнойЧасти.СуммаНДС = Окр(СуммаНДС, 2);
		СтрокаТабличнойЧасти.СуммаНСП = Окр(СуммаНСП, 2);											
	КонецЕсли;
КонецПроцедуры

// Рассчитывает всего в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти 	- Структура или СтрокаТабличнойЧасти - Строка табличной части документа.
//  СуммаВключаетНалоги	 	- Булево - Признак расчета суммы НДС и НСП
//
Процедура РассчитатьВсегоСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, СуммаВключаетНалоги) Экспорт

	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);
	
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

// Расчет, исходя из постоянной суммы
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа.
//
Процедура РассчитатьСуммуНДССтрокиТабличнойЧасти(СтрокаТабличнойЧасти, Период, Организация, СуммаВключаетНалоги = Ложь, СтавкаНДС = Неопределено, СтавкаНСП = Неопределено, БезналичныйРасчет = Ложь) Экспорт

	Если ТипЗнч(СтрокаТабличнойЧасти)=Тип("Структура") Тогда
		Если СтрокаТабличнойЧасти.Свойство("Сумма") 
			И СтрокаТабличнойЧасти.Свойство("СтавкаНДС")
			И СтрокаТабличнойЧасти.Свойство("СтавкаНСП") Тогда
			СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
				СтрокаТабличнойЧасти.Сумма,
				СуммаВключаетНалоги,
				?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС), УчетНДСВызовСервера.ПолучитьСтавкуНДС(Период, СтрокаТабличнойЧасти.СтавкаНДС), 0),
				?(БезналичныйРасчет Или НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНСП), 0, УчетНДСВызовСервера.ПолучитьСтавкуНСП(Период, Организация, СтрокаТабличнойЧасти.СтавкаНСП)));
		КонецЕсли;
	Иначе // Строка табличной части
		СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
			СтрокаТабличнойЧасти.Сумма,
			СуммаВключаетНалоги,
			?(ЗначениеЗаполнено(СтавкаНДС), УчетНДСВызовСервера.ПолучитьСтавкуНДС(Период, СтавкаНДС), 0),
			?(БезналичныйРасчет Или НЕ ЗначениеЗаполнено(СтавкаНСП), 0, УчетНДСВызовСервера.ПолучитьСтавкуНСП(Период, Организация, СтавкаНСП)));
	КонецЕсли;
		
	Если СтрокаТабличнойЧасти.Свойство("Всего") Тогда
		СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);
	КонецЕсли;	
КонецПроцедуры

// Расчет, исходя из постоянной суммы
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа.
//
Процедура РассчитатьСуммуНСПСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, Период, Организация, СуммаВключаетНалоги = Ложь, СтавкаНДС = Неопределено, СтавкаНСП = Неопределено, БезналичныйРасчет = Ложь) Экспорт

	Если ТипЗнч(СтрокаТабличнойЧасти)=Тип("Структура") Тогда
		Если СтрокаТабличнойЧасти.Свойство("Сумма") 
			И СтрокаТабличнойЧасти.Свойство("СтавкаНДС")
			И СтрокаТабличнойЧасти.Свойство("СтавкаНСП") Тогда
			СтрокаТабличнойЧасти.СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
				СтрокаТабличнойЧасти.Сумма,
				СуммаВключаетНалоги,
				?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС), УчетНДСВызовСервера.ПолучитьСтавкуНДС(Период, СтрокаТабличнойЧасти.СтавкаНДС), 0),
				?(БезналичныйРасчет Или НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНСП), 0, УчетНДСВызовСервера.ПолучитьСтавкуНСП(Период, Организация, СтрокаТабличнойЧасти.СтавкаНСП)));
		КонецЕсли;
	Иначе // Строка табличной части
		СтрокаТабличнойЧасти.СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
			СтрокаТабличнойЧасти.Сумма,
			СуммаВключаетНалоги,
			?(ЗначениеЗаполнено(СтавкаНДС), УчетНДСВызовСервера.ПолучитьСтавкуНДС(Период, СтавкаНДС), 0),
			?(БезналичныйРасчет Или НЕ ЗначениеЗаполнено(СтавкаНСП), 0, УчетНДСВызовСервера.ПолучитьСтавкуНСП(Период, Организация, СтавкаНСП)));
	КонецЕсли;

	Если СтрокаТабличнойЧасти.Свойство("Всего") Тогда
		СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);
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
//  ИмяТабличнойЧасти 	- Строка - Имя табличной части, в которой нужно переститать
//
Процедура ПересчитатьЦеныТабличнойЧастиПоВалюте(Объект, Период, СтруктураКурсыПред, СтруктураКурсы, ИмяТабличнойЧасти) Экспорт
	
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
//  ИмяТабличнойЧасти 		- Строка - Имя табличной части, в которой нужно переститать
//  СуммаВключаетНалоги	 	- Булево - Признак расчета суммы НДС и НСП
//  СтавкаНДС			 	- СправочникСсылка.СтавкиНДС - Ссылка на справочник ставки НДС для пересчета
//  СтавкаНСП			 	- СправочникСсылка.СтавкиНСП - Ссылка на справочник ставки НСП для пересчета
//  БезналичныйРасчет	 	- Булево - Признак безналичного расчета
//
Процедура ПересчитатьНалогиТабличнойЧасти(Объект, Период, Организация, ИмяТабличнойЧасти, СуммаВключаетНалоги = Ложь, СтавкаНДС = Неопределено, СтавкаНСП = Неопределено, БезналичныйРасчет = Ложь) Экспорт
	
	ЗначениеСтавкиНДС = ?(ЗначениеЗаполнено(СтавкаНДС), УчетНДСВызовСервера.ПолучитьСтавкуНДС(Период, СтавкаНДС), 0);
	ЗначениеСтавкиНСП = ?(БезналичныйРасчет Или НЕ ЗначениеЗаполнено(СтавкаНСП), 0, УчетНДСВызовСервера.ПолучитьСтавкуНСП(Период, Организация, СтавкаНСП));

	Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл
		// СуммаНДС.
		СтрокаТабличнойЧасти.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
			СтрокаТабличнойЧасти.Сумма,
			СуммаВключаетНалоги,
			ЗначениеСтавкиНДС,
			ЗначениеСтавкиНСП);
			
		// СуммаНСП.
		СтрокаТабличнойЧасти.СуммаНСП = УчетНДСКлиентСервер.РассчитатьСуммуНСП(
			СтрокаТабличнойЧасти.Сумма,
			СуммаВключаетНалоги,
			ЗначениеСтавкиНДС,
			ЗначениеСтавкиНСП);
			
		Если СтрокаТабличнойЧасти.Свойство("Всего") Тогда
			СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(СуммаВключаетНалоги, 0, СтрокаТабличнойЧасти.СуммаНДС + СтрокаТабличнойЧасти.СуммаНСП);
		КонецЕсли;
		
		Если СтрокаТабличнойЧасти.Свойство("СуммаДохода") Тогда
			СтрокаТабличнойЧасти.СуммаДохода	= СтрокаТабличнойЧасти.Всего - СтрокаТабличнойЧасти.СуммаНДС - СтрокаТабличнойЧасти.СуммаНСП;
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
//		* ПрямойКурс - Булево - призначк расчета курса (всегда рассчитывается отношение большего курса к меньшему)
//  ДанныВзаиморасчетов	- Структура - Данные взаиморасчетов
//		* Валюта	- СправочникСсылка.Валюты - Валюта расчетов
//		* Курс		- Число - Курс расчетов
//		* Кратность - Число - Кратность документа
//  ВалютаРегламентированногоУчета	 - СправочникСсылка.Валюты - Валюта регламентированного учета
//
Процедура РассчитатьСуммуВзаиморасчетовСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета) Экспорт

	// Валюта взаиморасчетов в валюте регламентированного учета. 
	Если ДанныВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда 
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
			СтрокаТабличнойЧасти.СуммаПлатежа, 
			Новый Структура("Валюта, Курс, Кратность", ДанныВзаиморасчетов.Валюта, ДанныВзаиморасчетов.Курс, ДанныВзаиморасчетов.Кратность),
			Новый Структура("Валюта, Курс, Кратность", ДанныеДокумента.Валюта, 1, 1));
			
	// В документа в валюте регламентированного учета.
	ИначеЕсли ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета Тогда  
		СтрокаТабличнойЧасти.СуммаВзаиморасчетов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
			СтрокаТабличнойЧасти.СуммаПлатежа, 
			Новый Структура("Валюта, Курс, Кратность", ДанныеДокумента.Валюта, ДанныеДокумента.Курс, ДанныеДокумента.Кратность),
			Новый Структура("Валюта, Курс, Кратность", ДанныВзаиморасчетов.Валюта, ДанныВзаиморасчетов.Курс, ДанныВзаиморасчетов.Кратность));
			
	// В любой другой валюте.
	Иначе		
		Если ДанныеДокумента.ПрямойКурс Тогда 
			СтрокаТабличнойЧасти.СуммаВзаиморасчетов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
				СтрокаТабличнойЧасти.СуммаПлатежа, 
				Новый Структура("Валюта, Курс, Кратность", ДанныВзаиморасчетов.Валюта, ДанныВзаиморасчетов.Курс, ДанныВзаиморасчетов.Кратность),
				Новый Структура("Валюта, Курс, Кратность", ДанныеДокумента.Валюта, 1, 1));
		Иначе
			СтрокаТабличнойЧасти.СуммаВзаиморасчетов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
				СтрокаТабличнойЧасти.СуммаПлатежа,
				Новый Структура("Валюта, Курс, Кратность", ДанныеДокумента.Валюта, 1, 1),
				Новый Структура("Валюта, Курс, Кратность", ДанныВзаиморасчетов.Валюта, ДанныВзаиморасчетов.Курс, ДанныВзаиморасчетов.Кратность));	
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
//  ДанныВзаиморасчетов	- Структура - Данные взаиморасчетов
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
//  ИмяТабличнойЧасти 		- Строка - Имя табличной части, в которой нужно переститать
//  ДанныеДокумента			- Структура - Данные документа
//		* Валюта	- СправочникСсылка.Валюты - Валюта документа
//		* Курс		- Число - Курс документа
//		* Кратность - Число - Кратность документа
//  ДанныВзаиморасчетов	- Структура - Данные взаиморасчетов
//		* Валюта	- СправочникСсылка.Валюты - Валюта расчетов
//		* Курс		- Число - Курс расчетов
//		* Кратность - Число - Кратность документа
//  ВалютаРегламентированногоУчета	 - СправочникСсылка.Валюты - Валюта регламентированного учета
//
Процедура УстановитьКурсыВзаиморасчетовТабличнойЧасти(Объект, ИмяТабличнойЧасти, ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета) Экспорт
	
	Если ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И ДанныВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда 
		Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс;
		Объект.КратностьВзаиморасчетов = ДанныеДокумента.Кратность;
	// 2. Валюта документа USD, валюта расчетов USD.
	ИначеЕсли НЕ ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И ДанныВзаиморасчетов.Валюта = ДанныеДокумента.Валюта Тогда
		Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс;
		Объект.КратностьВзаиморасчетов = ДанныеДокумента.Кратность;
	// 3. Валюта документа KGS, валюта расчетов USD.
	ИначеЕсли ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И НЕ ДанныВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда
		Объект.КурсВзаиморасчетов = ДанныВзаиморасчетов.Курс;
		Объект.КратностьВзаиморасчетов = ДанныВзаиморасчетов.Кратность;
		Объект.ПрямойКурс = Ложь;
	// 4. Валюта документа USD, валюта расчетов KGS.
	ИначеЕсли НЕ ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И ДанныВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда
		Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс;
		Объект.КратностьВзаиморасчетов = ДанныеДокумента.Кратность;
		Объект.ПрямойКурс = Истина;
	// 5. Валюта документа USD, валюта расчетов RUB.
	ИначеЕсли НЕ ДанныеДокумента.Валюта = ВалютаРегламентированногоУчета
		И НЕ ДанныВзаиморасчетов.Валюта = ВалютаРегламентированногоУчета Тогда
		
		Если ДанныеДокумента.Курс >= ДанныВзаиморасчетов.Курс 
			И ДанныеДокумента.Кратность >= ДанныВзаиморасчетов.Кратность Тогда 
			Если ДанныВзаиморасчетов.Курс * ДанныеДокумента.Кратность = 0 Тогда 
				Объект.КурсВзаиморасчетов = 0;
			Иначе 			
				Объект.КурсВзаиморасчетов = ДанныеДокумента.Курс * ДанныВзаиморасчетов.Кратность / ДанныВзаиморасчетов.Курс * ДанныеДокумента.Кратность;
			КонецЕсли;
			
			Объект.КратностьВзаиморасчетов = 1;
			Объект.ПрямойКурс = Истина;
		Иначе
			Если ДанныеДокумента.Курс * ДанныВзаиморасчетов.Кратность = 0 Тогда 
				Объект.КурсВзаиморасчетов = 0;
			Иначе 	
				Объект.КурсВзаиморасчетов = ДанныВзаиморасчетов.Курс * ДанныеДокумента.Кратность / ДанныеДокумента.Курс * ДанныВзаиморасчетов.Кратность;
			КонецЕсли;
			
			Объект.КратностьВзаиморасчетов = 1;
			Объект.ПрямойКурс = Ложь;
		КонецЕсли;	
	КонецЕсли;
	
	// Обновление данных структуры.
	ДанныеДокумента.ПрямойКурс = Объект.ПрямойКурс;
	ДанныВзаиморасчетов.Курс = Объект.КурсВзаиморасчетов; 
	ДанныВзаиморасчетов.Кратность = Объект.КратностьВзаиморасчетов; 	

КонецПроцедуры

// Рассчитывает сумму взаиморасчетов в табличной части документа
//
// Параметры:
//  Объект					- Объект - Объект пересчета
//  ИмяТабличнойЧасти 		- Строка - Имя табличной части, в которой нужно переститать
//  ДанныеДокумента			- Структура - Данные документа
//		* Валюта	- СправочникСсылка.Валюты - Валюта документа
//		* Курс		- Число - Курс документа
//		* Кратность - Число - Кратность документа
//  ДанныВзаиморасчетов	- Структура - Данные взаиморасчетов
//		* Валюта	- СправочникСсылка.Валюты - Валюта расчетов
//		* Курс		- Число - Курс расчетов
//		* Кратность - Число - Кратность документа
//  ВалютаРегламентированногоУчета	 - СправочникСсылка.Валюты - Валюта регламентированного учета
//
Процедура РассчитатьСуммуВзаиморасчетовТабличнойЧасти(Объект, ИмяТабличнойЧасти, ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета) Экспорт
	Для Каждого СтрокаТабличнойЧасти Из Объект[ИмяТабличнойЧасти] Цикл 
		РассчитатьСуммуВзаиморасчетовСтрокиТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеДокумента, ДанныВзаиморасчетов, ВалютаРегламентированногоУчета);
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


