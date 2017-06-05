﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       см. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина);

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "");
	НастройкиВарианта.Описание = НСтр("ru = 'Отчет о бланках счет-фактур НДС с производственным браком.'");

	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
		НСтр("ru = 'КОД и НАИМЕНОВАНИЕ НАЛОГОВОГО ОРГАНА
		|СЕРИЯ И №ПАСПОРТА
		|ПОЧТ.ИНДЕКС
		|№ ТЕЛЕФОНА
		|НОМЕР НАЦСТАТКОМА
		|ОБЛАСТЬ, ГОРОД/ОБЛ., РАЙОН, СЕЛО
		|УЛИЦА/МИКР., № ДОМА, КВАРТИРЫ
		|НАЛОГОВЫЙ ПЕРИОД С
		|НАЛОГОВЫЙ ПЕРИОД ПО
		|КОЛИЧЕСТВО
		|СЕРИЯ
		|ДИАПАЗОН НОМЕРОВ С НОМЕРА
		|ДИАПАЗОН НОМЕРОВ ПО НОМЕР
		|ИТОГО
		|ВСЕГО
		|НОМЕР ЗАКЛЮЧИТЕЛЬНОГО ЛИСТА
		|НОМЕР ТЕКУЩЕГО ЛИСТА
		|Индентификационный номер плательщика'");
	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
		НСтр("ru = 'НачалоПериода
		|КонецПериода
		|Организация'");
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Отчет о бланках счет-фактур НДС с производственным браком'");
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Процедура формирования отчета.
//
// Параметры:
// ПараметрыОтчета - структура - набор параметров, необходимых для построения отчета.
// 	АдресХранилища - адрес временного хранилища.
Процедура Сформировать(СтруктураПараметров, АдресХранилища) Экспорт
	
	РезультатФормирования = Новый Структура("Результат, ОписаниеОшибки", Неопределено, "");
	СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования);
	ПоместитьВоВременноеХранилище(РезультатФормирования, АдресХранилища);
	
КонецПроцедуры

// Процедура - Сформировать табличный документ
//
// Параметры:
//  СтруктураПараметров	 - Структура - Параметры формирования отчета.
//  РезультатФормирования	 	- Структура - 
//
Процедура СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ЧерноБелаяПечать = Истина;
	
	Организация = СтруктураПараметров.Организация;
	НачалоПериода = СтруктураПараметров.НачалоПериода;
	КонецПериода = СтруктураПараметров.КонецПериода;
	
	Макет = ПолучитьМакет("ПФ_MXL_БланкиСФПроизводственныйБрак");

	ОКПО              				= Организация.КодПоОКПО;
	ИНН 							= Организация.ИНН;
	КодГНС 							= Организация.ГНС.Код;
	ОрганизацияНаменованиеПолное    = Организация.НаименованиеПолное;
	
	КонтактныеДанные = ПолучитьКонтактнуюИнформацию(Организация);
	
	Индекс           = КонтактныеДанные.Индекс;
	АдрОбластьГород  = КонтактныеДанные.АдрОбластьГород;
	ЮрАдрес	         = КонтактныеДанные.АдресОрганизации; 
	Телефон		     = КонтактныеДанные.Телефон;
	
	НомерЯчейки = 210;	

	ОбластьШапка			= Макет.ПолучитьОбласть("Шапка");
	ОбластьДетали 			= Макет.ПолучитьОбласть("Детали");
	ОбластьИтого 			= Макет.ПолучитьОбласть("Итоги");
	ОбластьВсего 			= Макет.ПолучитьОбласть("Всего");
	ОбластьПодвал 			= Макет.ПолучитьОбласть("Подвал");
	ОбластьПодпись			= Макет.ПолучитьОбласть("Подпись");
	ОбластьНомерЛиста		= Макет.ПолучитьОбласть("НомерЛиста");
	ОбластьНомерЗаклЛиста	= Макет.ПолучитьОбласть("НомерЗаклЛиста");
	ОбластьЗаголовок		= Макет.ПолучитьОбласть("Заголовок");	
	
	ОбластьШапка.Параметры.НомерЛиста1 = "0";
	ОбластьШапка.Параметры.НомерЛиста2 = "0";
	ОбластьШапка.Параметры.НомерЛиста3 = "1";
		
	ОбластьШапка.Параметры.НаменованиеОрганизации = ОрганизацияНаменованиеПолное;
	Если ЗначениеЗаполнено(АдрОбластьГород) Тогда 
		ОбластьШапка.Параметры.Область = АдрОбластьГород;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЮрАдрес) Тогда 
		ОбластьШапка.Параметры.Адрес = ЮрАдрес;
	КонецЕсли;
	
	ОбластьШапка.Параметры.Телефон = Телефон;
	
	Если ЗначениеЗаполнено(Индекс) ТОгда
		
		ОбластьШапка.Параметры.ИНД1 = Сред(Индекс,1,1);
		ОбластьШапка.Параметры.ИНД2 = Сред(Индекс,2,1);
		ОбластьШапка.Параметры.ИНД3 = Сред(Индекс,3,1);
		ОбластьШапка.Параметры.ИНД4 = Сред(Индекс,4,1);
		ОбластьШапка.Параметры.ИНД5 = Сред(Индекс,5,1);
		ОбластьШапка.Параметры.ИНД6 = Сред(Индекс,6,1);
		
	КонецЕсли;

	Если ЗначениеЗаполнено(ОКПО) Тогда 
		ОбластьШапка.Параметры.ОКПО1 = Сред(ОКПО,1,1);
		ОбластьШапка.Параметры.ОКПО2 = Сред(ОКПО,2,1);
		ОбластьШапка.Параметры.ОКПО3 = Сред(ОКПО,3,1);
		ОбластьШапка.Параметры.ОКПО4 = Сред(ОКПО,4,1);
		ОбластьШапка.Параметры.ОКПО5 = Сред(ОКПО,5,1);
		ОбластьШапка.Параметры.ОКПО6 = Сред(ОКПО,6,1);
		ОбластьШапка.Параметры.ОКПО7 = Сред(ОКПО,7,1);
		ОбластьШапка.Параметры.ОКПО8 = Сред(ОКПО,8,1);
	КонецЕсли;
	
	ОбластьШапка.Параметры.ИНН1 = Сред(ИНН, 1, 1);
	ОбластьШапка.Параметры.ИНН2 = Сред(ИНН, 2, 1);
	ОбластьШапка.Параметры.ИНН3 = Сред(ИНН, 3, 1);                           
	ОбластьШапка.Параметры.ИНН4 = Сред(ИНН, 4, 1);
	ОбластьШапка.Параметры.ИНН5 = Сред(ИНН, 5, 1);
	ОбластьШапка.Параметры.ИНН6 = Сред(ИНН, 6, 1);
	ОбластьШапка.Параметры.ИНН7 = Сред(ИНН, 7, 1);
	ОбластьШапка.Параметры.ИНН8 = Сред(ИНН, 8, 1);
	ОбластьШапка.Параметры.ИНН9 = Сред(ИНН, 9, 1);
	ОбластьШапка.Параметры.ИНН10 = Сред(ИНН, 10, 1);
	ОбластьШапка.Параметры.ИНН11 = Сред(ИНН, 11, 1);
	ОбластьШапка.Параметры.ИНН12 = Сред(ИНН, 12, 1);
	ОбластьШапка.Параметры.ИНН13 = Сред(ИНН, 13, 1);
	ОбластьШапка.Параметры.ИНН14 = Сред(ИНН, 14, 1);
	
	ОбластьШапка.Параметры.НаименованиеНалоговой = Организация.ГНС;
	
	ОбластьШапка.Параметры.Код1 = Сред(КодГНС, 1, 1);
	ОбластьШапка.Параметры.Код2 = Сред(КодГНС, 2, 1);
	ОбластьШапка.Параметры.Код3 = Сред(КодГНС, 3, 1);
	
	ОбластьШапка.Параметры.ДН1 = Сред(НачалоПериода, 1, 1);	
	ОбластьШапка.Параметры.ДН2 = Сред(НачалоПериода, 2, 1);	
	ОбластьШапка.Параметры.ДН3 = Сред(НачалоПериода, 4, 1);	
	ОбластьШапка.Параметры.ДН4 = Сред(НачалоПериода, 5, 1);	
	ОбластьШапка.Параметры.ДН5 = Сред(НачалоПериода, 7, 1);	
	ОбластьШапка.Параметры.ДН6 = Сред(НачалоПериода, 8, 1);	
	ОбластьШапка.Параметры.ДН7 = Сред(НачалоПериода, 9, 1);	
	ОбластьШапка.Параметры.ДН8 = Сред(НачалоПериода, 10, 1);	
	
	ОбластьШапка.Параметры.ДК1 = Сред(КонецПериода, 1, 1);	
	ОбластьШапка.Параметры.ДК2 = Сред(КонецПериода, 2, 1);	
	ОбластьШапка.Параметры.ДК3 = Сред(КонецПериода, 4, 1);	
	ОбластьШапка.Параметры.ДК4 = Сред(КонецПериода, 5, 1);	
	ОбластьШапка.Параметры.ДК5 = Сред(КонецПериода, 7, 1);	
	ОбластьШапка.Параметры.ДК6 = Сред(КонецПериода, 8, 1);	
	ОбластьШапка.Параметры.ДК7 = Сред(КонецПериода, 9, 1);	
	ОбластьШапка.Параметры.ДК8 = Сред(КонецПериода, 10, 1);
	
	ТабличныйДокумент.Вывести(ОбластьШапка);

	Запрос = Новый Запрос;
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	БланкиСФОбороты.Номер КАК БланкНомер,
		|	БланкиСФОбороты.Серия КАК Серия,
		|	ЕСТЬNULL(БланкиСФОбороты.КоличествоРасход, 0) КАК Количество
		|ИЗ
		|	РегистрНакопления.БланкиСФ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			,
		|			Операция = &Операция
		|				И Организация = &Организация) КАК БланкиСФОбороты
		|
		|УПОРЯДОЧИТЬ ПО
		|	Серия,
		|	БланкНомер
		|ИТОГИ
		|	МИНИМУМ(БланкНомер),
		|	СУММА(Количество)
		|ПО
		|	Серия
		|АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(НачалоПериода));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(КонецПериода));	
	Запрос.УстановитьПараметр("Операция", Перечисления.ВидыОперацийСФ.ПроизводственныйБракБланковСФ);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос.УстановитьПараметр("Организация", Организация);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Организация = &Организация", "Истина");
	КонецЕсли;		
	
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаСерии = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ОбщееКолвоПозиций = 0;
	
	НомерЯчейки = 202;		
	
	КоличествоВыделенных = 0;
	Заключительный = Ложь;
	НомерСтраницы = 1;
	НомерСтроки = 1;
	кол = 0;
	ТекущаяСерия = Неопределено;
	ПредыдущийНомер = -100; // Здесь надо ставить любой точно не реальный номер;
	
	Пока ВыборкаСерии.Следующий() Цикл
		ОбластьДетали.Параметры.Серия 	= ВыборкаСерии.Серия;
		ОбластьДетали.Параметры.НомерОт = ВыборкаСерии.БланкНомер;
		ПредыдущийНомер 				= Число(ВыборкаСерии.БланкНомер) - 1;
		ПервыйНомерИнтервала			= ВыборкаСерии.БланкНомер;
		ПоследнийНомерИнтервала			= Число(ВыборкаСерии.БланкНомер);
		ВыборкаНомера = ВыборкаСерии.Выбрать();
		ОбщееКолвоПозиций = ОбщееКолвоПозиций + ВыборкаСерии.Количество;
		
		Пока ВыборкаНомера.Следующий() Цикл
			ПроверяемыйНомер = Число(ВыборкаНомера.БланкНомер);
			Если ПроверяемыйНомер = (ПредыдущийНомер + 1) Тогда
				ПредыдущийНомер = ПроверяемыйНомер;
				ПоследнийНомерИнтервала = ПроверяемыйНомер;
			Иначе 
				ОбластьДетали.Параметры.НомерОт = ПервыйНомерИнтервала;
				ОбластьДетали.Параметры.НомерПо = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Строка(ПредыдущийНомер), 6, "0", "Слева");
				ВыводОбластиДетали(ТабличныйДокумент, Макет, ОбластьДетали, НомерЯчейки, НомерСтраницы, ОбщееКолвоПозиций, КоличествоВыделенных, кол, НомерСтроки, Заключительный);
				ПредыдущийНомер					= Число(ВыборкаНомера.БланкНомер);
				ПервыйНомерИнтервала			= ВыборкаНомера.БланкНомер;
			КонецЕсли;
		
		КонецЦикла;
		ОбластьДетали.Параметры.НомерОт = ПервыйНомерИнтервала;
		ОбластьДетали.Параметры.НомерПо = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Строка(ПредыдущийНомер), 6, "0", "Слева");
		ВыводОбластиДетали(ТабличныйДокумент, Макет, ОбластьДетали, НомерЯчейки, НомерСтраницы, ОбщееКолвоПозиций, КоличествоВыделенных, кол, НомерСтроки, Заключительный);
	КонецЦикла; // Конец серии
	
	//После цикла проверяем количество выведенных строк на последний лист, и если их число < 17 или 24 то добавляем пустые строки
	Пока НомерСтроки < ?(НомерСтраницы = 1,17,24) Цикл
		ОбластьДетали = Макет.ПолучитьОбласть("Детали");
		ОбластьДетали.Параметры.Ном1 = НомерЯчейки + 1;
		ОбластьДетали.Параметры.Ном2 = НомерЯчейки + 2;
		ОбластьДетали.Параметры.Ном3 = НомерЯчейки + 3;
		ОбластьДетали.Параметры.Ном4 = НомерЯчейки + 4;

		НомерЯчейки = НомерЯчейки + 4;
		НомерСтроки = НомерСтроки + 1;
		ТабличныйДокумент.Вывести(ОбластьДетали);
	КонецЦикла;
	
	ОбластьВсего.Параметры.Количество = ОбщееКолвоПозиций;
	ОбластьВсего.Параметры.Ном = НомерЯчейки + 1;
	ТабличныйДокумент.Вывести(ОбластьВсего);
	ВывестиРазделитель = Истина;
		
	Если НомерСтраницы <> 1 Тогда 
		ТабличныйДокумент.Вывести(ОбластьПодпись);
	Иначе 
		ТабличныйДокумент.Вывести(ОбластьПодвал);
	КонецЕсли;
	
	РезультатФормирования.Результат = ТабличныйДокумент;
КонецПроцедуры

// Процедура - Вывод области детали
//
// Параметры:
//  ТабличныйДокумент				 - 	 - 
//  Макет				 - 	 - 
//  НомерЯчейки			 - 	 - 
//  НомерСтраницы		 - 	 - 
//  ОбщееКолвоПозиций	 - 	 - 
//  КоличествоВыделенных		 - 	 - 
//  Количество			 - 	 - 
//  НомерСтроки			 - 	 - 
//  Заключительный		 - 	 - 
//
Процедура ВыводОбластиДетали(ТабличныйДокумент, Макет, ОбластьДетали, НомерЯчейки, НомерСтраницы, ОбщееКолвоПозиций, КоличествоВыделенных, Количество, НомерСтроки, Заключительный)

	ОбластьИтого 			= Макет.ПолучитьОбласть("Итоги");
	ОбластьПодвал 			= Макет.ПолучитьОбласть("Подвал");
	ОбластьПодпись			= Макет.ПолучитьОбласть("Подпись");
	ОбластьНомерЛиста		= Макет.ПолучитьОбласть("НомерЛиста");
	ОбластьНомерЗаклЛиста	= Макет.ПолучитьОбласть("НомерЗаклЛиста");
	ОбластьЗаголовок		= Макет.ПолучитьОбласть("Заголовок");
	
	ОбластьДетали.Параметры.Ном1 = НомерЯчейки + 1;
	ОбластьДетали.Параметры.Ном2 = НомерЯчейки + 2;
	ОбластьДетали.Параметры.Ном3 = НомерЯчейки + 3;
	ОбластьДетали.Параметры.Ном4 = НомерЯчейки + 4;

	НомерЯчейки = НомерЯчейки + 4;
	
	ОбластьДетали.Параметры.Количество 	= Число(ОбластьДетали.Параметры.НомерПо) - Число(ОбластьДетали.Параметры.НомерОт) + 1;
	Количество = Количество + ОбластьДетали.Параметры.Количество;
	
	НомерСтроки = НомерСтроки + 1;
	КоличествоВыделенных = КоличествоВыделенных + 1;
	ТабличныйДокумент.Вывести(ОбластьДетали);
	
	// Вывод нового листа <<
	Если НомерСтраницы = 1 и НомерСтроки = 17 ИЛИ НомерСтроки = 24 Тогда
		Если (ОбщееКолвоПозиций - КоличествоВыделенных) < 24 Тогда 
			Заключительный = Истина
		КонецЕсли;
		
		НомерЯчейки = НомерЯчейки + 1;
		ОбластьИтого.Параметры.Ном = НомерЯчейки;
		ОбластьИтого.Параметры.Количество = Количество;
		ТабличныйДокумент.Вывести(ОбластьИтого);
		
		Если НомерСтраницы <> 1 Тогда 
			ТабличныйДокумент.Вывести(ОбластьПодпись);
		Иначе 
			ТабличныйДокумент.Вывести(ОбластьПодвал);
		КонецЕсли;
							
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		НомерСтраницы = НомерСтраницы + 1;
		Если Не Заключительный Тогда
			
			Если СтрДлина(Формат(НомерСтраницы,"ЧГ=0")) = 1 Тогда
				ОбластьНомерЛиста.Параметры.НомерЛиста1 = "0";
				ОбластьНомерЛиста.Параметры.НомерЛиста2 = "0";
				ОбластьНомерЛиста.Параметры.НомерЛиста3 = НомерСтраницы;
			ИначеЕсли СтрДлина(Формат(НомерСтраницы,"ЧГ=0")) = 2 Тогда
				ОбластьНомерЛиста.Параметры.НомерЛиста1 = "0";
				ОбластьНомерЛиста.Параметры.НомерЛиста2 = Сред(НомерСтраницы, 1,1);
				ОбластьНомерЛиста.Параметры.НомерЛиста3 = Сред(НомерСтраницы, 2,1);
			ИначеЕсли СтрДлина(Формат(НомерСтраницы,"ЧГ=0")) = 3 Тогда
				ОбластьНомерЛиста.Параметры.НомерЛиста1 = Сред(НомерСтраницы, 1,1);
				ОбластьНомерЛиста.Параметры.НомерЛиста2 = Сред(НомерСтраницы, 2,1);
				ОбластьНомерЛиста.Параметры.НомерЛиста3 = Сред(НомерСтраницы, 3,1);
			КонецЕсли;				
			ТабличныйДокумент.Вывести(ОбластьНомерЛиста);
			
		Иначе
			
			Если СтрДлина(Формат(НомерСтраницы,"ЧГ=0")) = 1 Тогда
				ОбластьНомерЗаклЛиста.Параметры.НомерЛиста1 = "0";
				ОбластьНомерЗаклЛиста.Параметры.НомерЛиста2 = "0";
				ОбластьНомерЗаклЛиста.Параметры.НомерЛиста3 = НомерСтраницы;
			ИначеЕсли СтрДлина(Формат(НомерСтраницы,"ЧГ=0")) = 2 Тогда
				ОбластьНомерЗаклЛиста.Параметры.НомерЛиста1 = "0";
				ОбластьНомерЗаклЛиста.Параметры.НомерЛиста2 = Сред(НомерСтраницы, 1,1);
				ОбластьНомерЗаклЛиста.Параметры.НомерЛиста3 = Сред(НомерСтраницы, 2,1);
			ИначеЕсли СтрДлина(Формат(НомерСтраницы,"ЧГ=0")) = 3 Тогда
				ОбластьНомерЗаклЛиста.Параметры.НомерЛиста1 = Сред(НомерСтраницы, 1,1);
				ОбластьНомерЗаклЛиста.Параметры.НомерЛиста2 = Сред(НомерСтраницы, 2,1);
				ОбластьНомерЗаклЛиста.Параметры.НомерЛиста3 = Сред(НомерСтраницы, 3,1);
			КонецЕсли;				
			ТабличныйДокумент.Вывести(ОбластьНомерЗаклЛиста);
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		НомерСтроки = 1;
		кол = 0;
	КонецЕсли;
	
	// >> Вывод нового листа	
	
КонецПроцедуры

// Функция -ПолучитьКонтактнуюИнформацию
//
// Параметры:
//  Организация  - Спр.Ссылка - Спр.Органинизации 
// Возвращаемое значение:
//  Структура   - структура данных контактной информации
//
Функция ПолучитьКонтактнуюИнформацию(Организация)
	
	СтруктураКонтактнойИнформации = УправлениеКонтактнойИнформациейКлиентСервер.СтруктураКонтактнойИнформацииПоТипу(Перечисления.ТипыКонтактнойИнформации.Адрес);
	ТаблицаКонтактнойИнформации = УправлениеКонтактнойИнформацией.ТаблицаКонтактнойИнформацииОбъекта(Организация, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
	
	Если ТаблицаКонтактнойИнформации.Количество() > 0 Тогда 		
		СтруктураКонтактнойИнформации = ТаблицаКонтактнойИнформации[0].СтруктураПолей;
	КонецЕсли;
	Если СтруктураКонтактнойИнформации.Количество() > 3 Тогда 
		Индекс		    = СтруктураКонтактнойИнформации.Индекс; 
		ГородНасПункт   = ?(СтруктураКонтактнойИнформации.Город  = "",СтруктураКонтактнойИнформации.НаселенныйПункт,СтруктураКонтактнойИнформации.Город);
		АдрОбластьГород = ?(СтруктураКонтактнойИнформации.Регион = "","",СтруктураКонтактнойИнформации.Регион + ",")
		                + ?(СтруктураКонтактнойИнформации.Район  = "","", " " + СтруктураКонтактнойИнформации.Район + ",") 
						+ ?(ГородНасПункт = "",""," " + ГородНасПункт); 
		АдресОрганизации = ?(СтруктураКонтактнойИнформации.Улица    = "","",СтруктураКонтактнойИнформации.Улица + ",")
						 + ?(СтруктураКонтактнойИнформации.Дом      = "",""," " + СтруктураКонтактнойИнформации.Дом + ",")
						 + ?(СтруктураКонтактнойИнформации.Корпус   = "",""," " + СтруктураКонтактнойИнформации.Корпус + ",")
						 + ?(СтруктураКонтактнойИнформации.Квартира = "",""," " + СтруктураКонтактнойИнформации.Квартира);
		
	Иначе
		Индекс			 = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Организация, Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресОрганизации); 
		АдрОбластьГород  = ""; 
		АдресОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Организация, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);		
	КонецЕсли;	
	
	Телефон		= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Организация, Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);
	
	Структура = Новый Структура("Индекс,АдрОбластьГород,АдресОрганизации,Телефон", Индекс,АдрОбластьГород,АдресОрганизации,Телефон);
	
	Возврат Структура;
	
КонецФункции // ПолучитьАдресОрганизации()

#КонецОбласти

#КонецЕсли
