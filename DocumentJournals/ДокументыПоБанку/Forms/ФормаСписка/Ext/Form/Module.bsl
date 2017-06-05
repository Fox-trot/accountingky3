﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СписокЗначений = Новый СписокЗначений;
	ВыборкаОрганизаций = Справочники.Организации.Выбрать();
	Пока ВыборкаОрганизаций.Следующий() Цикл
		СписокЗначений.Добавить(ВыборкаОрганизаций.Ссылка);
	КонецЦикла;
	СписокОрганизаций = СписокЗначений;
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Организация = Настройки.Получить("Организация");
	БанковскийСчет = Настройки.Получить("БанковскийСчет");
	Контрагент = Настройки.Получить("Контрагент");
	
	Если ЗначениеЗаполнено(Организация) Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец", Организация);
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.БанковскийСчет.ПараметрыВыбора = НовыеПараметры;
	Иначе
		НовыйМассив = Новый Массив();
		Для каждого Элемент Из СписокОрганизаций Цикл
			НовыйМассив.Добавить(Элемент.Значение);
		КонецЦикла;
		ФиксированныйМассивОрганизации = Новый ФиксированныйМассив(НовыйМассив);
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец", ФиксированныйМассивОрганизации);
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.БанковскийСчет.ПараметрыВыбора = НовыеПараметры;
	КонецЕсли;
	
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(БанковскиеВыписки, "ОрганизацияДляОтбора", Организация, ЗначениеЗаполнено(Организация));
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(БанковскиеВыписки, "Контрагент", Контрагент, ЗначениеЗаполнено(Контрагент));
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(БанковскиеВыписки, "БанковскийСчет", БанковскийСчет, ЗначениеЗаполнено(БанковскийСчет));
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(БанковскиеВыписки, "БанковскийСчет", БанковскийСчет, ЗначениеЗаполнено(БанковскийСчет));
	
КонецПроцедуры // БанковскийСчетПриИзменении()

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(БанковскиеВыписки, "Контрагент", Контрагент, ЗначениеЗаполнено(Контрагент));
	
КонецПроцедуры // КонтрагентПриИзменении()

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец", Организация);
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.БанковскийСчет.ПараметрыВыбора = НовыеПараметры;
		
	Иначе
		
		НовыйМассив = Новый Массив();
		Для каждого Элемент Из СписокОрганизаций Цикл
			НовыйМассив.Добавить(Элемент.Значение);
		КонецЦикла;
		ФиксированныйМассивОрганизации = Новый ФиксированныйМассив(НовыйМассив);
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец", ФиксированныйМассивОрганизации);
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(НовыйПараметр);
		НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
		Элементы.БанковскийСчет.ПараметрыВыбора = НовыеПараметры;
		
	КонецЕсли;
	
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(БанковскиеВыписки, "ОрганизацияДляОтбора", Организация, ЗначениеЗаполнено(Организация));
	
КонецПроцедуры // ОрганизацияПриИзменении()

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	
	Состояние(
		НСтр("ru = 'Загрузка из файла'"),
		,
		НСтр("ru = 'В данный момент в разработке'"),
		БиблиотекаКартинок.ЗагрузкаДанных32
	);
	
КонецПроцедуры // ЗагрузитьИзФайла()

&НаКлиенте
Процедура БанковскиеВыпискиПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
	
КонецПроцедуры // БанковскиеВыпискиПриАктивизацииСтроки()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		Подключаемый_ОбработатьАктивизациюСтрокиСписка();
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

&НаКлиенте
Процедура ВедомостьПерейти(Команда)
	
	Состояние(
		НСтр("ru = 'Отчет.ДенежныеСредства'"),
		,
		НСтр("ru = 'В данный момент в разработке'"),
		БиблиотекаКартинок.ЗагрузкаДанных32
	);

	
	//ОткрытьФорму("Отчет.ДенежныеСредства.Форма", Новый Структура("КлючВарианта", "Ведомость"));
	
КонецПроцедуры // ВедомостьПерейти()

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ОбработатьАктивизациюСтрокиСписка()
	
	ТекущаяСтрока = Элементы.БанковскиеВыписки.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		СтруктураДанные = ПолучитьДанныеПоБанковскомуСчету(ТекущаяСтрока.Дата, ТекущаяСтрока.БанковскийСчет);
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураДанные);
		Элементы.СостояниеБанковскогоСчета.Заголовок = Формат(ТекущаяСтрока.Дата, "ДЛФ=D");
	Иначе
		ИнформацияСуммаВалКонечныйОстаток = 0;
		ИнформацияСуммаВалНачальныйОстаток = 0;
		ИнформацияСуммаВалПриход = 0;
		ИнформацияСуммаВалРасход = 0;
		Элементы.СостояниеБанковскогоСчета.Заголовок = "";
	Конецесли;
	
КонецПроцедуры // ОбработатьАктивизациюСтрокиСписка()

&НаСервереБезКонтекста
Функция ПолучитьДанныеПоБанковскомуСчету(Период, БанковскийСчет)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ХозрасчетныйОстаткиИОбороты.СуммаНачальныйОстаток КАК ИнформацияСуммаВалНачальныйОстаток,
		|	ХозрасчетныйОстаткиИОбороты.СуммаОборотДт КАК ИнформацияСуммаВалПриход,
		|	ХозрасчетныйОстаткиИОбороты.СуммаОборотКт КАК ИнформацияСуммаВалРасход,
		|	ХозрасчетныйОстаткиИОбороты.СуммаКонечныйОстаток КАК ИнформацияСуммаВалКонечныйОстаток
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, День, , Счет = &Счет, ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ДенежныеСредства), Субконто1 = &БанковскийСчет) КАК ХозрасчетныйОстаткиИОбороты";
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(Период));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(Период));
	Запрос.УстановитьПараметр("Счет", БанковскийСчет.СчетУчета);
	Запрос.УстановитьПараметр("БанковскийСчет", БанковскийСчет);
	
	ВыборкаРезультата = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаРезультата.Следующий() Тогда
		СтруктураВозврата = Новый Структура("ИнформацияСуммаВалНачальныйОстаток, ИнформацияСуммаВалКонечныйОстаток, ИнформацияСуммаВалПриход, ИнформацияСуммаВалРасход");
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, ВыборкаРезультата);
		Возврат СтруктураВозврата;
	Иначе
		Возврат Новый Структура(
			"ИнформацияСуммаВалКонечныйОстаток, ИнформацияСуммаВалНачальныйОстаток, ИнформацияСуммаВалПриход, ИнформацияСуммаВалРасход",
			0,0,0,0
		);
	КонецЕсли;
	
КонецФункции // ПолучитьДанныеПобанковскомуСчету()

#КонецОбласти