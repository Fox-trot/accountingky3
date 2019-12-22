﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если СверкаПоСоцФонду Тогда  
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");		
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДаннымБухгалтерскогоУчета() Экспорт
	
	Если СверкаПоСоцФонду Тогда 
		ЗапросТекст = 
			"ВЫБРАТЬ
			|	ХозрасчетныйОборотыДтКт.Регистратор КАК ДокументСверки,
			|	ХозрасчетныйОборотыДтКт.СуммаОборот КАК СуммаДт,
			|	0 КАК СуммаКт
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, Авто, СчетДт В (&СписокСчетов), , , , Организация = &Организация) КАК ХозрасчетныйОборотыДтКт
			|ГДЕ
			|	ВЫБОР
			|		КОГДА &УчитыватьВзаимозачеты
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ НЕ (ХозрасчетныйОборотыДтКт.Регистратор ССЫЛКА Документ.ОперацияБух
			|			ИЛИ ХозрасчетныйОборотыДтКт.Регистратор ССЫЛКА Документ.КорректировкаДолга)
			|	КОНЕЦ
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ХозрасчетныйОборотыДтКт.Регистратор,
			|	0,
			|	ХозрасчетныйОборотыДтКт.СуммаОборот
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, Авто, , , СчетКт В (&СписокСчетов), , Организация = &Организация) КАК ХозрасчетныйОборотыДтКт
			|ГДЕ
			|	ВЫБОР
			|		КОГДА &УчитыватьВзаимозачеты
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ НЕ (ХозрасчетныйОборотыДтКт.Регистратор ССЫЛКА Документ.ОперацияБух
			|			ИЛИ ХозрасчетныйОборотыДтКт.Регистратор ССЫЛКА Документ.КорректировкаДолга)
			|	КОНЕЦ";
		// Временно.
		// Нужно переделать запросы ниже под общий формат.
		Запрос = Новый Запрос;
		Запрос.Текст = ЗапросТекст;
		Запрос.УстановитьПараметр("Организация", 			Организация);
		Запрос.УстановитьПараметр("НачалоПериода", 			НачалоДня(ДатаНачала));
		Запрос.УстановитьПараметр("КонецПериода", 			КонецДня(ДатаОкончания));
		Запрос.УстановитьПараметр("СписокСчетов", 			СписокСчетов.Выгрузить().ВыгрузитьКолонку("СчетУчета"));
		Запрос.УстановитьПараметр("УчитыватьВзаимозачеты", 	УчитыватьВзаимозачеты);

		ПоДаннымОрганизации.Загрузить(Запрос.Выполнить().Выгрузить());
		
		Возврат;
		
	Иначе
		// Список контрагентов.
		СписокКонтрагентов = Новый СписокЗначений;
		СписокКонтрагентов.Добавить(Контрагент);
		Если ПоГоловномуКонтрагенту Тогда 
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	Контрагенты.Ссылка КАК Контрагент
				|ИЗ
				|	Справочник.Контрагенты КАК Контрагенты
				|ГДЕ
				|	Контрагенты.ГоловнойКонтрагент = &Контрагент
				|	И НЕ Контрагенты.ПометкаУдаления";
			Запрос.УстановитьПараметр("Контрагент", Контрагент);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				СписокКонтрагентов.Добавить(ВыборкаДетальныеЗаписи.Контрагент);	
			КонецЦикла;
		КонецЕсли;	
		
		Если ПоказатьВнутренниеОбороты Тогда
			ЗапросТекст =
			"ВЫБРАТЬ
			|	ХозрасчетныйОстаткиИОбороты.ПериодСекунда КАК Дата,
			|	ХозрасчетныйОстаткиИОбороты.Регистратор КАК Документ,
			|	ХозрасчетныйОстаткиИОбороты.Субконто2 КАК Договор,
			|	СУММА(ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотДт) КАК Дебет,
			|	СУММА(0) КАК Кредит,
			|	1 КАК Группа
			|ПОМЕСТИТЬ ВременнаяТаблицаДанные
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
			|			&ДатаНачала,
			|			&ДатаОкончания,
			|			Авто,
			|			,
			|			Счет В (&СписокСчетов),
			|			,
			|			Организация = &Организация
			|				И Валюта = &Валюта
			|				И Субконто1 В (&СписокКонтрагентов)
			|				И Субконто2 = &Договор) КАК ХозрасчетныйОстаткиИОбороты
			|ГДЕ
			|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотДт <> 0
			|	И ВЫБОР
			|		КОГДА &УчитыватьВзаимозачеты
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ НЕ (ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.ОперацияБух
			|			ИЛИ ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.КорректировкаДолга)
			|	КОНЕЦ
			|
			|СГРУППИРОВАТЬ ПО
			|	ХозрасчетныйОстаткиИОбороты.Регистратор,
			|	ХозрасчетныйОстаткиИОбороты.ПериодСекунда,
			|	ХозрасчетныйОстаткиИОбороты.Субконто2
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ХозрасчетныйОстаткиИОбороты.ПериодСекунда,
			|	ХозрасчетныйОстаткиИОбороты.Регистратор,
			|	ХозрасчетныйОстаткиИОбороты.Субконто2,
			|	СУММА(0),
			|	СУММА(ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотКт),
			|	2
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
			|			&ДатаНачала,
			|			&ДатаОкончания,
			|			Авто,
			|			,
			|			Счет В (&СписокСчетов),
			|			,
			|			Организация = &Организация
			|				И Валюта = &Валюта
			|				И Субконто1 В (&СписокКонтрагентов)
			|				И Субконто2 = &Договор) КАК ХозрасчетныйОстаткиИОбороты
			|ГДЕ
			|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотКт <> 0
			|	И ВЫБОР
			|		КОГДА &УчитыватьВзаимозачеты
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ НЕ (ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.ОперацияБух
			|			ИЛИ ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.КорректировкаДолга)
			|	КОНЕЦ
			|
			|СГРУППИРОВАТЬ ПО
			|	ХозрасчетныйОстаткиИОбороты.Регистратор,
			|	ХозрасчетныйОстаткиИОбороты.ПериодСекунда,
			|	ХозрасчетныйОстаткиИОбороты.Субконто2
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВременнаяТаблицаДанные.Дата КАК Дата,
			|	ВременнаяТаблицаДанные.Документ КАК Документ,
			|	ВременнаяТаблицаДанные.Договор КАК Договор,
			|	СУММА(ВременнаяТаблицаДанные.Дебет) КАК Дебет,
			|	СУММА(ВременнаяТаблицаДанные.Кредит) КАК Кредит,
			|	ВременнаяТаблицаДанные.Группа КАК Группа
			|ИЗ
			|	ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные
			|
			|СГРУППИРОВАТЬ ПО
			|	ВременнаяТаблицаДанные.Дата,
			|	ВременнаяТаблицаДанные.Документ,
			|	ВременнаяТаблицаДанные.Группа,
			|	ВременнаяТаблицаДанные.Договор
			|
			|УПОРЯДОЧИТЬ ПО
			|	Дата,
			|	Документ,
			|	Группа";			
			
		Иначе
			ЗапросТекст = 
			// 1. Валютные суммы оборотов.
			// 2. Суммы оборотов в регламентированной валюте.
			// 3. Группировка 1 пакета по документам и договорам. 
			// 4. Отсечение внутренних оборотов из 3 пакета.
			// 5. Группировка 1 пакета по документам, контрагентам, валюте и договорам.
			// 6. Отсечение внутренних оборотов из 5 пакета.
			// 7. Группировка 1 пакета по документам, контрагентам и договорам.
			// 8. Отсечение внутренних оборотов из 7 пакета.
			"ВЫБРАТЬ
			|	ХозрасчетныйОстаткиИОбороты.ПериодСекунда КАК Дата,
			|	ХозрасчетныйОстаткиИОбороты.Регистратор КАК Документ,
			|	ХозрасчетныйОстаткиИОбороты.Субконто1 КАК Контрагент,
			|	ХозрасчетныйОстаткиИОбороты.Субконто2 КАК Договор,
			|	ХозрасчетныйОстаткиИОбороты.Валюта КАК Валюта,
			|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотДт КАК Дебет,
			|	0 КАК Кредит,
			|	1 КАК Группа
			|ПОМЕСТИТЬ ВременнаяТаблицаДанные
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
			|			&ДатаНачала,
			|			&ДатаОкончания,
			|			Авто,
			|			,
			|			Счет В (&СписокСчетов),
			|			,
			|			Организация = &Организация
			|				И Валюта = &Валюта
			|				И Субконто1 В (&СписокКонтрагентов)
			|				И Субконто2 = &Договор) КАК ХозрасчетныйОстаткиИОбороты
			|ГДЕ
			|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотДт <> 0
			|	И ВЫБОР
			|		КОГДА &УчитыватьВзаимозачеты
			|			ТОГДА ИСТИНА 
			|		ИНАЧЕ НЕ (ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.ОперацияБух
			|			ИЛИ ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.КорректировкаДолга)
			|	КОНЕЦ
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ХозрасчетныйОстаткиИОбороты.ПериодСекунда,
			|	ХозрасчетныйОстаткиИОбороты.Регистратор,
			|	ХозрасчетныйОстаткиИОбороты.Субконто1,
			|	ХозрасчетныйОстаткиИОбороты.Субконто2,
			|	ХозрасчетныйОстаткиИОбороты.Валюта,
			|	0,
			|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотКт,
			|	2
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
			|			&ДатаНачала,
			|			&ДатаОкончания,
			|			Авто,
			|			,
			|			Счет В (&СписокСчетов),
			|			,
			|			Организация = &Организация
			|				И Валюта = &Валюта
			|				И Субконто1 В (&СписокКонтрагентов)
			|				И Субконто2 = &Договор) КАК ХозрасчетныйОстаткиИОбороты
			|ГДЕ
			|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотКт <> 0
			|	И ВЫБОР
			|		КОГДА &УчитыватьВзаимозачеты
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ НЕ (ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.ОперацияБух
			|			ИЛИ ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.КорректировкаДолга)
			|	КОНЕЦ
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ХозрасчетныйОстаткиИОбороты.ПериодСекунда КАК Дата,
			|	ХозрасчетныйОстаткиИОбороты.Регистратор КАК Документ,
			|	ХозрасчетныйОстаткиИОбороты.Субконто1 КАК Контрагент,
			|	ХозрасчетныйОстаткиИОбороты.Субконто2 КАК Договор,
			|	ХозрасчетныйОстаткиИОбороты.СуммаОборотДт КАК Дебет,
			|	0 КАК Кредит,
			|	1 КАК Группа
			|ПОМЕСТИТЬ ВременнаяТаблицаДанныеВРегВалюте
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
			|			&ДатаНачала,
			|			&ДатаОкончания,
			|			Авто,
			|			,
			|			Счет В (&СписокСчетов),
			|			,
			|			Организация = &Организация
			|				И Субконто1 В (&СписокКонтрагентов)) КАК ХозрасчетныйОстаткиИОбороты
			|ГДЕ
			|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотДт <> 0
			|	И ВЫБОР
			|		КОГДА &УчитыватьВзаимозачеты
			|			ТОГДА ИСТИНА 
			|		ИНАЧЕ НЕ (ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.ОперацияБух
			|			ИЛИ ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.КорректировкаДолга)
			|	КОНЕЦ
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ХозрасчетныйОстаткиИОбороты.ПериодСекунда,
			|	ХозрасчетныйОстаткиИОбороты.Регистратор,
			|	ХозрасчетныйОстаткиИОбороты.Субконто1,
			|	ХозрасчетныйОстаткиИОбороты.Субконто2,
			|	0,
			|	ХозрасчетныйОстаткиИОбороты.СуммаОборотКт,
			|	2
			|ИЗ
			|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(
			|			&ДатаНачала,
			|			&ДатаОкончания,
			|			Авто,
			|			,
			|			Счет В (&СписокСчетов),
			|			,
			|			Организация = &Организация
			|				И Субконто1 В (&СписокКонтрагентов)) КАК ХозрасчетныйОстаткиИОбороты
			|ГДЕ
			|	ХозрасчетныйОстаткиИОбороты.ВалютнаяСуммаОборотКт <> 0
			|	И ВЫБОР
			|		КОГДА &УчитыватьВзаимозачеты
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ НЕ (ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.ОперацияБух
			|			ИЛИ ХозрасчетныйОстаткиИОбороты.Регистратор ССЫЛКА Документ.КорректировкаДолга)
			|	КОНЕЦ
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВременнаяТаблицаДанные.Дата КАК Дата,
			|	ВременнаяТаблицаДанные.Документ КАК Документ,
			|	ВременнаяТаблицаДанные.Договор КАК Договор,
			|	СУММА(ВременнаяТаблицаДанные.Дебет) КАК Дебет,
			|	СУММА(ВременнаяТаблицаДанные.Кредит) КАК Кредит,
			|	МАКСИМУМ(ВременнаяТаблицаДанные.Группа) КАК Группа
			|ПОМЕСТИТЬ ВременнаяТаблицаДанныеПоДоговорам
			|ИЗ
			|	ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные
			|
			|СГРУППИРОВАТЬ ПО
			|	ВременнаяТаблицаДанные.Дата,
			|	ВременнаяТаблицаДанные.Документ,
			|	ВременнаяТаблицаДанные.Договор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТаблицаДанныеПоДоговорам.Дата КАК Дата,
			|	ТаблицаДанныеПоДоговорам.Документ КАК Документ,
			|	ТаблицаДанныеПоДоговорам.Договор КАК Договор,
			|	ТаблицаДанныеПоДоговорам.Дебет КАК Дебет,
			|	ТаблицаДанныеПоДоговорам.Кредит КАК Кредит,
			|	ТаблицаДанныеПоДоговорам.Группа КАК Группа
			|ИЗ
			|	ВременнаяТаблицаДанныеПоДоговорам КАК ТаблицаДанныеПоДоговорам
			|ГДЕ
			|	ТаблицаДанныеПоДоговорам.Дебет <> ТаблицаДанныеПоДоговорам.Кредит
			|
			|УПОРЯДОЧИТЬ ПО
			|	Дата,
			|	Документ,
			|	Группа
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВременнаяТаблицаДанные.Дата КАК Дата,
			|	ВременнаяТаблицаДанные.Документ КАК Документ,
			|	ВременнаяТаблицаДанные.Контрагент КАК Контрагент,
			|	ВременнаяТаблицаДанные.Договор КАК Договор,
			|	ВременнаяТаблицаДанные.Валюта КАК Валюта,
			|	СУММА(ВременнаяТаблицаДанные.Дебет) КАК Дебет,
			|	СУММА(ВременнаяТаблицаДанные.Кредит) КАК Кредит,
			|	МАКСИМУМ(ВременнаяТаблицаДанные.Группа) КАК Группа
			|ПОМЕСТИТЬ ВременнаяТаблицаДанныеПоКонтагентамИВалюте
			|ИЗ
			|	ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные
			|
			|СГРУППИРОВАТЬ ПО
			|	ВременнаяТаблицаДанные.Дата,
			|	ВременнаяТаблицаДанные.Документ,
			|	ВременнаяТаблицаДанные.Контрагент,
			|	ВременнаяТаблицаДанные.Валюта,
			|	ВременнаяТаблицаДанные.Договор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТаблицаДанныеПоКонтагентамИВалюте.Дата КАК Дата,
			|	ТаблицаДанныеПоКонтагентамИВалюте.Документ КАК Документ,
			|	ТаблицаДанныеПоКонтагентамИВалюте.Контрагент КАК Контрагент,
			|	ТаблицаДанныеПоКонтагентамИВалюте.Договор КАК Договор,
			|	ТаблицаДанныеПоКонтагентамИВалюте.Дебет КАК Дебет,
			|	ТаблицаДанныеПоКонтагентамИВалюте.Кредит КАК Кредит,
			|	ТаблицаДанныеПоКонтагентамИВалюте.Группа КАК Группа
			|ИЗ
			|	ВременнаяТаблицаДанныеПоКонтагентамИВалюте КАК ТаблицаДанныеПоКонтагентамИВалюте
			|ГДЕ
			|	ТаблицаДанныеПоКонтагентамИВалюте.Дебет <> ТаблицаДанныеПоКонтагентамИВалюте.Кредит
			|
			|УПОРЯДОЧИТЬ ПО
			|	Дата,
			|	Документ,
			|	Группа
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВременнаяТаблицаДанныеВРегВалюте.Дата КАК Дата,
			|	ВременнаяТаблицаДанныеВРегВалюте.Документ КАК Документ,
			|	ВременнаяТаблицаДанныеВРегВалюте.Контрагент КАК Контрагент,
			|	ВременнаяТаблицаДанныеВРегВалюте.Договор КАК Договор,
			|	СУММА(ВременнаяТаблицаДанныеВРегВалюте.Дебет) КАК Дебет,
			|	СУММА(ВременнаяТаблицаДанныеВРегВалюте.Кредит) КАК Кредит,
			|	МАКСИМУМ(ВременнаяТаблицаДанныеВРегВалюте.Группа) КАК Группа
			|ПОМЕСТИТЬ ВременнаяТаблицаДанныеПоКонтагентам
			|ИЗ
			|	ВременнаяТаблицаДанныеВРегВалюте КАК ВременнаяТаблицаДанныеВРегВалюте
			|
			|СГРУППИРОВАТЬ ПО
			|	ВременнаяТаблицаДанныеВРегВалюте.Дата,
			|	ВременнаяТаблицаДанныеВРегВалюте.Документ,
			|	ВременнаяТаблицаДанныеВРегВалюте.Контрагент,
			|	ВременнаяТаблицаДанныеВРегВалюте.Договор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТаблицаДанныеПоКонтагентам.Дата КАК Дата,
			|	ТаблицаДанныеПоКонтагентам.Документ КАК Документ,
			|	ТаблицаДанныеПоКонтагентам.Контрагент КАК Контрагент,
			|	ТаблицаДанныеПоКонтагентам.Договор КАК Договор,
			|	ТаблицаДанныеПоКонтагентам.Дебет КАК Дебет,
			|	ТаблицаДанныеПоКонтагентам.Кредит КАК Кредит,
			|	ТаблицаДанныеПоКонтагентам.Группа КАК Группа
			|ИЗ
			|	ВременнаяТаблицаДанныеПоКонтагентам КАК ТаблицаДанныеПоКонтагентам
			|ГДЕ
			|	ТаблицаДанныеПоКонтагентам.Дебет <> ТаблицаДанныеПоКонтагентам.Кредит
			|
			|УПОРЯДОЧИТЬ ПО
			|	Дата,
			|	Документ,
			|	Группа";	
		КонецЕсли;
		
		Если ДоговорКонтрагента.Пустая() Тогда
			ЗапросТекст = СтрЗаменить(ЗапросТекст, "И Субконто2 = &Договор", "");
		КонецЕсли;
		
		Если ВалютаСверки.Пустая() Тогда
			ЗапросТекст = СтрЗаменить(ЗапросТекст, "И Валюта = &Валюта", "");		
		КонецЕсли;			
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ЗапросТекст;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СписокКонтрагентов", СписокКонтрагентов);
	Запрос.УстановитьПараметр("Договор", ДоговорКонтрагента);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ДатаОкончания));
	Запрос.УстановитьПараметр("Валюта", ВалютаСверки);
	Запрос.УстановитьПараметр("СписокСчетов", СписокСчетов.Выгрузить().ВыгрузитьКолонку("СчетУчета"));
	Запрос.УстановитьПараметр("УчитыватьВзаимозачеты", УчитыватьВзаимозачеты);

	Если СверкаПоСоцФонду ИЛИ ПоказатьВнутренниеОбороты Тогда
		
		Выборка = Запрос.Выполнить().Выбрать();
		
	Иначе		
		Если ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка() И ВалютаСверки = Справочники.Валюты.ПустаяСсылка() Тогда
			Выборка = Запрос.Выполнить().Выбрать();
			
		ИначеЕсли ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка() Тогда
			Выборка = Запрос.ВыполнитьПакет()[5].Выбрать();
			
		Иначе
			Выборка = Запрос.ВыполнитьПакет()[3].Выбрать();
		КонецЕсли; 	
	КонецЕсли;				
	
	Пока Выборка.Следующий() Цикл 
		СТЧ = ПоДаннымОрганизации.Добавить();
		СТЧ.ДокументСверки 	= Выборка.Документ;
		СТЧ.Договор 		= Выборка.Договор;
		
		Если Выборка.Дебет-Выборка.Кредит > 0 Тогда 
			СТЧ.СуммаДт = Выборка.Дебет-Выборка.Кредит;
		Иначе 
			СТЧ.СуммаКт = Выборка.Кредит-Выборка.Дебет;
		КонецЕсли;
	КонецЦикла;
	
	Если Запрос.Выполнить().Пустой() Тогда 
		Если СверкаПоСоцФонду Тогда 
			ТекстСообщения = НСтр("ru = 'Для введенных данных за указанный период нет никаких операций.'");
		Иначе 
			ТекстСообщения = НСтр("ru = 'Проверьте правильность заполнения контрагента и договора, для введенных данных за указанный период нет никаких операций.'");
		КонецЕсли;
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли