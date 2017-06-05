﻿
#Область СлужебныеПроцедурыИФункции

#Область ПолнотекстовыйПоиск

&НаСервереБезКонтекста
// Функция заполняет массив ссылок результата поиска или возвращает описание ошибки
//
//
Функция ПолнотекстовыйПоискНаСервереБезКонтекста(СтрокаПоиска, РезультатПоиска)
	
	ОписаниеОшибки = "";
	РезультатПоиска = ПоискОС(СтрокаПоиска, ОписаниеОшибки);
	
	Возврат ОписаниеОшибки;
	
КонецФункции // ПолнотекстовыйПоискНаСервереБезКонтекста()

&НаСервереБезКонтекста
Функция ПолнотекстовыйПоискОС(СтрокаПоиска, РезультатПоиска)
	
	// Поиск данных
	РазмерПорции = 200;
	ОбластьПоиска = Новый Массив;
	ОбластьПоиска.Добавить(Метаданные.Справочники.ОсновныеСредства);
	
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска, РазмерПорции);
	СписокПоиска.ПолучатьОписание = Ложь;
	СписокПоиска.ОбластьПоиска = ОбластьПоиска;
	СписокПоиска.ПерваяЧасть();
	
	Если СписокПоиска.СлишкомМногоРезультатов() Тогда
		Возврат "СлишкомМногоРезультатов";
	КонецЕсли;
	
	КоличествоНайденныхЭлементов = СписокПоиска.ПолноеКоличество();
	Если КоличествоНайденныхЭлементов = 0 Тогда
		Возврат "НичегоНеНайдено";
	КонецЕсли;
	
	// Обработка данных
	НачальнаяПозиция	= 0;
	КонечнаяПозиция		= ?(КоличествоНайденныхЭлементов > РазмерПорции, РазмерПорции, КоличествоНайденныхЭлементов) - 1;
	ЕстьСледующаяПорция = Истина;

	Пока ЕстьСледующаяПорция Цикл
		
		Для СчетчикЭлементов = 0 По КонечнаяПозиция Цикл
			
			Элемент = СписокПоиска.Получить(СчетчикЭлементов);
			
			Если Элемент.Метаданные = Метаданные.Справочники.ОсновныеСредства Тогда
				РезультатПоиска.ОС.Добавить(Элемент.Значение);
			Иначе
				ВызватьИсключение НСтр("ru = 'Неизвестная ошибка'");
			КонецЕсли;
			
		КонецЦикла;
		
		НачальнаяПозиция    = НачальнаяПозиция + РазмерПорции;
		ЕстьСледующаяПорция = (НачальнаяПозиция < КоличествоНайденныхЭлементов - 1);
		
		Если ЕстьСледующаяПорция Тогда
			
			КонечнаяПозиция = ?(КоличествоНайденныхЭлементов > НачальнаяПозиция + РазмерПорции,
			                    РазмерПорции,
			                    КоличествоНайденныхЭлементов - НачальнаяПозиция
			                    ) - 1;
			СписокПоиска.СледующаяЧасть();
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат "ВыполненоУспешно";
	
КонецФункции

&НаСервереБезКонтекста
Функция ПоискОС(СтрокаПоиска, ОписаниеОшибки) Экспорт
	
	РезультатПоиска = Новый Структура;
	РезультатПоиска.Вставить("ОС", Новый Массив);
	
	Результат = ПолнотекстовыйПоискОС(СтрокаПоиска, РезультатПоиска);
	
	Если Результат = "ВыполненоУспешно" Тогда
		
		Возврат РезультатПоиска;
		
	ИначеЕсли Результат = "СлишкомМногоРезультатов" Тогда
		
		ОписаниеОшибки = НСтр("ru = 'Слишком много результатов. Уточните запрос.'");
		Возврат РезультатПоиска;
		
	ИначеЕсли Результат = "НичегоНеНайдено" Тогда
		
		ОписаниеОшибки = НСтр("ru = 'Ничего не найдено'");
		Возврат РезультатПоиска;
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Неизвестная ошибка'");
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
// Процедура устанавливает отбор по ссылкам полученными полнотекстовым поиском
//
Процедура ПолнотекстовыйПоискНаКлиенте()
	
	Если НЕ ПустаяСтрока(ТекстПоиска) Тогда
		
		РезультатПоиска = Неопределено;
		ОписаниеОшибки = ПолнотекстовыйПоискНаСервереБезКонтекста(ТекстПоиска, РезультатПоиска);
		
		Если ПустаяСтрока(ОписаниеОшибки) Тогда
			Использование = РезультатПоиска.ОС.Количество() > 0;
			МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(СписокОС.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, "ОССсылка");
			Если МассивЭлементов.Количество() = 0 Тогда
				
				ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СписокОС.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
					"ОССсылка", ВидСравненияКомпоновкиДанных.ВСписке, РезультатПоиска.ОС, , Использование);
			Иначе
				ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(СписокОС.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
					"ОССсылка", , РезультатПоиска.ОС, ВидСравненияКомпоновкиДанных.ВСписке, Использование);
			КонецЕсли;
			
			ЭтаФорма.ТекущийЭлемент = Элементы.СписокОС;
		Иначе
			ПоказатьПредупреждение(Неопределено, ОписаниеОшибки, 5, "Поиск...");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПолнотекстовыйПоискНаКлиенте()

&НаКлиенте
// Процедура устанавливает отбор по ссылкам полученными контектным поиском
//
Процедура КонтекстныйПоискНаКлиенте()
	
	ПредставлениеГруппыПолей = "Контекстный поиск";
	
	Если ПустаяСтрока(ТекстПоиска) Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокОС, "ОССсылка", ПредставлениеГруппыПолей);
		
	Иначе
		
		МассивОтборов = СформироватьМассивОтбораПоОС(ТекстПоиска);
		
		МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(СписокОС.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, , ПредставлениеГруппыПолей);
		Если МассивЭлементов.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СписокОС.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
				"ОССсылка", ВидСравненияКомпоновкиДанных.Равно, МассивОтборов, ПредставлениеГруппыПолей, Истина);
		Иначе
			ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(СписокОС.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
				"ОССсылка", ПредставлениеГруппыПолей, МассивОтборов, ВидСравненияКомпоновкиДанных.Равно, Истина);
		КонецЕсли;
		
		ЭтаФорма.ТекущийЭлемент = Элементы.СписокОС;
	КонецЕсли;
	
КонецПроцедуры // КонтекстныйПоискНаКлиенте()

&НаСервереБезКонтекста
Функция СформироватьМассивОтбораПоОС(ТекстПоиска)
	
	ТекстЗапроса = 
	"Выбрать СпрОС.Ссылка КАК ОССсылка
	|Поместить ОСПоНаименование Из Справочник.ОсновныеСредства КАК СпрОС
	|Где СпрОС.Наименование ПОДОБНО &ТекстПоиска;
	|////////////////////////////////////////////////////////////////////////////
	|Выбрать СпрОС.Ссылка КАК ОССсылка
	|Поместить ОСПоПолномуНаименованию Из Справочник.ОсновныеСредства КАК СпрОС
	|Где СпрОС.НаименованиеПолное ПОДОБНО &ТекстПоиска;
	|////////////////////////////////////////////////////////////////////////////
	|Выбрать СпрОС.Ссылка КАК ОССсылка
	|Поместить ОСПоКомментарию Из Справочник.ОсновныеСредства КАК СпрОС
	|Где СпрОС.Комментарий ПОДОБНО &ТекстПоиска;
	|////////////////////////////////////////////////////////////////////////////
	|Выбрать ОСПоНаименование.ОССсылка КАК ОССсылка
	|Объединить
	|Выбрать ОСПоПолномуНаименованию.ОССсылка
	|Объединить
	|Выбрать ОСПоКомментарию.ОССсылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТекстПоиска", "%" + ТекстПоиска + "%");
	ВременнаяТаблицаНоменклатуры = Запрос.Выполнить().Выгрузить();
	
	Возврат ВременнаяТаблицаНоменклатуры.ВыгрузитьКолонку("ОССсылка");
	
КонецФункции

&НаКлиенте
// Процедура инициализирует выполнение полнотекстового поиска и установку отбора
// 
Процедура ВыполнитьПоискИУстановитьОтбор()
	
	Если ИспользоватьПолнотекстовыйПоиск Тогда
		ПолнотекстовыйПоискНаКлиенте();
	Иначе
		КонтекстныйПоискНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьПоискИУстановитьОтбор()

&НаСервере
// Процедура устанавливает подсказку ввода для элемента формы ПоискТекста
//
Процедура УстановитьПодсказкуВводаСтрокиПоискаНаСервере()
	
	ПолнотекстовыйПоискНастроенЧастично = (ИспользоватьПолнотекстовыйПоиск И НЕ АктуальностьИндексаППД);
	ПодсказкаВвода = ?(ПолнотекстовыйПоискНастроенЧастично, НСтр("ru = 'Необходимо обновить индекс полнотекстового поиска...'"), НСтр("ru = '(ALT+F3) Введите текст поиска...'"));
	Элементы.ТекстПоиска.ПодсказкаВвода = ПодсказкаВвода;
	
КонецПроцедуры // УстановитьПодсказкуВводаСтрокиПоискаНаСервере()

&НаСервере
// Процедура подключает полнотекстовый поиск и устанавливает свойства реквизитов формы
//
Процедура ПодключитьПолнотекстовыйПоискПриОткрытииПодбора()
	
	ИспользоватьПолнотекстовыйПоиск = ПолучитьФункциональнуюОпцию("ИспользоватьПолнотекстовыйПоиск");
	Если ИспользоватьПолнотекстовыйПоиск Тогда
		
		АктуальностьИндексаППД = ПолнотекстовыйПоиск.ИндексАктуален();
		
		Если НЕ АктуальностьИндексаППД Тогда
			
			Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
				И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
				
				//в разделенной ИБ считаем актуальным индекс в пределах 2 дней
				АктуальностьИндексаППД = ПолнотекстовыйПоиск.ДатаАктуальности() >= (ТекущаяДатаСеанса()-(2*24*60*60));
				
			Иначе
				
				//в неразделенной ИБ считаем актуальным индекс в пределах дня
				АктуальностьИндексаППД = ПолнотекстовыйПоиск.ДатаАктуальности() >= (ТекущаяДатаСеанса() - (1*24*60*60));
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПодсказкуВводаСтрокиПоискаНаСервере();
	
КонецПроцедуры // ПодключитьПолнотекстовыйПоискПриОткрытииПодбора()

#КонецОбласти

#Область ДобавлениеВКорзину

&НаКлиенте
// Функция возвращает текущие данные строки элемента формы табличное поле
//
Функция ПолучитьДанныеТекущейСтрокиСписка()
	Возврат Элементы.СписокОС.ТекущиеДанные;
КонецФункции // ПолучитьДанныеТекущейСтрокиСписка()

&НаКлиенте
// Функция ищет строки в корзине подбора с указанной ОС
// 	используется перед добавление ОС в корзину.
//
// Возвращает:
//		- Неопределено, если ОС не найдена;
//		- Строку корзины, если ОС найдена;
//
Функция НайтиОСВКорзине(ДанныеТекущейСтроки)
	
	СтруктураОтбора = Новый Структура("ОсновноеСредство", ДанныеТекущейСтроки.ОССсылка);
	НайденныеСтроки = Объект.Корзина.НайтиСтроки(СтруктураОтбора);
	
	Возврат ?(НайденныеСтроки.Количество() = 0, Неопределено, НайденныеСтроки[0]);
	
КонецФункции // НайтиОСВКорзине()

&НаКлиенте
// Процедура добавления ОС в корзину подбора
//
Процедура ДобавитьОСВКорзину()
	
	ДанныеТекущейСтроки = ПолучитьДанныеТекущейСтрокиСписка();
	Если ДанныеТекущейСтроки = Неопределено
		Или ДанныеТекущейСтроки.Подобран Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтрокиКорзины = Новый Структура;
	
	НайденнаяСтрока = НайтиОСВКорзине(ДанныеТекущейСтроки);
	ДанныеСтрокиКорзины.Вставить("СтрокаКорзины", ?(НайденнаяСтрока <> Неопределено, НайденнаяСтрока.ПолучитьИдентификатор(), НайденнаяСтрока));
	ДанныеСтрокиКорзины.Вставить("ОсновноеСредство", ДанныеТекущейСтроки.ОССсылка);
	
	Если НайденнаяСтрока <> Неопределено 
		И ЗначениеЗаполнено(НайденнаяСтрока.Стоимость) Тогда
		
		ДанныеСтрокиКорзины.Вставить("Стоимость", НайденнаяСтрока.Стоимость);
	Иначе
		ДанныеСтрокиКорзины.Вставить("Стоимость", ДанныеТекущейСтроки.Стоимость);
	КонецЕсли;
	
	Если КешНастройкиПодбора.ЗапрашиватьСтоимость Тогда
		
		ДанныеСтрокиКорзины.Вставить("КешНастройкиПодбора",	КешНастройкиПодбора);
		ДанныеСтрокиКорзины.Вставить("Количество",			1);
		ДанныеСтрокиКорзины.Вставить("Стоимость",			ДанныеСтрокиКорзины.Стоимость);
		
		ОписаниеОповещенияПриЗакрытииПодбора = Новый ОписаниеОповещения("ПослеВыбораСтоимости", ЭтотОбъект, ДанныеСтрокиКорзины);
		ОткрытьФорму("Обработка.ПодборОС.Форма.ФормаИзмененияСтоимости", 
			ДанныеСтрокиКорзины, ЭтаФорма, Истина, , ,ОписаниеОповещенияПриЗакрытииПодбора , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		Если ДанныеСтрокиКорзины.СтрокаКорзины = Неопределено Тогда
			СтрокаКорзины = Объект.Корзина.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаКорзины, ДанныеСтрокиКорзины);
			
			СтрокаКорзины.Стоимость = ДанныеСтрокиКорзины.Стоимость;
		Иначе
			СтрокаКорзины = НайденнаяСтрока;
		КонецЕсли;
		
		СтрокаКорзины.Количество = 1;
	КонецЕсли;
	
КонецПроцедуры // ДобавитьОСВКорзину()

#КонецОбласти

#Область УправлениеСписками

&НаКлиенте
// Процедура обновляет динамические списки Запасы
//
Процедура ОбновитьОтборПоГруппеДинамическихСписков()
	
	Если КешНастройкиПодбора.ТекущийВидОтбора = "ОтборПоПапкамОС" Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокОС, "ГруппаИмущества");
		ИмяДинамическогоСписка = "СписокИерархияОС";
		ИмяОтбора = "Родитель";
		
	ИначеЕсли КешНастройкиПодбора.ТекущийВидОтбора = "ОтборПоГруппамИмущества" Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокОС, "Родитель");
		ИмяДинамическогоСписка = "СписокИерархияОСПоГруппамИмущества";
		ИмяОтбора = "ГруппаИмущества";
		
	КонецЕсли;
	
	ДанныеТекущейСтроки = Элементы[ИмяДинамическогоСписка].ТекущиеДанные;
	Если ДанныеТекущейСтроки = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокОС, ИмяОтбора);
	Иначе
		
		МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(СписокОС.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, ИмяОтбора);
		Если МассивЭлементов.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(СписокОС.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, ИмяОтбора, ВидСравненияКомпоновкиДанных.ВИерархии, ДанныеТекущейСтроки.Ссылка);
		Иначе
			ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(СписокОС.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, ИмяОтбора, , ДанныеТекущейСтроки.Ссылка, ВидСравненияКомпоновкиДанных.ВИерархии);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры //ОбновитьОтборПоГруппеДинамическихСписков()

&НаСервере
Процедура УстановитьТекстЗапросаСписокОС(ЭтоДокументПоступления)
	Если ЭтоДокументПоступления Тогда 
		ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ВЫБОР
			|		КОГДА СправочникОсновныеСредства.ЭтоГруппа
			|			ТОГДА ВЫБОР
			|					КОГДА СправочникОсновныеСредства.ПометкаУдаления
			|						ТОГДА 13
			|					ИНАЧЕ 12
			|				КОНЕЦ
			|		ИНАЧЕ -1 + ВЫБОР
			|				КОГДА СправочникОсновныеСредства.ПометкаУдаления
			|					ТОГДА 4
			|				ИНАЧЕ 3
			|			КОНЕЦ
			|	КОНЕЦ КАК ИндексКартинки,
			|	СправочникОсновныеСредства.Ссылка КАК ОССсылка,
			|	СправочникОсновныеСредства.Родитель КАК Родитель,
			|	СправочникОсновныеСредства.Код КАК Код,
			|	СправочникОсновныеСредства.Наименование КАК Наименование,
			|	СправочникОсновныеСредства.ГруппаИмущества КАК ГруппаИмущества,
			|	"""" КАК ИнвентарныйНомер,
			|	0 КАК Стоимость,
			|	"""" КАК Состояние,
			|	ВЫБОР
			|		КОГДА СправочникОсновныеСредства.Ссылка В (&СписокПодобранных)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК Подобран
			|ИЗ
			|	Справочник.ОсновныеСредства КАК СправочникОсновныеСредства
			|ГДЕ
			|	НЕ СправочникОсновныеСредства.ЭтоГруппа
			|	И НЕ СправочникОсновныеСредства.Ссылка В
			|				(ВЫБРАТЬ
			|					СостоянияОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство
			|				ИЗ
			|					РегистрСведений.СостоянияОС.СрезПоследних(&Дата, Организация = &Организация) КАК СостоянияОССрезПоследних)";
	Иначе 
		ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ВЫБОР
			|		КОГДА СправочникОсновныеСредства.ЭтоГруппа
			|			ТОГДА ВЫБОР
			|					КОГДА СправочникОсновныеСредства.ПометкаУдаления
			|						ТОГДА 13
			|					ИНАЧЕ 12
			|				КОНЕЦ
			|		ИНАЧЕ -1 + ВЫБОР
			|				КОГДА СправочникОсновныеСредства.ПометкаУдаления
			|					ТОГДА 4
			|				ИНАЧЕ 3
			|			КОНЕЦ
			|	КОНЕЦ КАК ИндексКартинки,
			|	СправочникОсновныеСредства.Ссылка КАК ОССсылка,
			|	СправочникОсновныеСредства.Родитель КАК Родитель,
			|	СправочникОсновныеСредства.Код КАК Код,
			|	СправочникОсновныеСредства.Наименование КАК Наименование,
			|	СправочникОсновныеСредства.ГруппаИмущества КАК ГруппаИмущества,
			|	ПараметрыУчетаОССрезПоследних.ИнвентарныйНомер КАК ИнвентарныйНомер,
			|	ПараметрыУчетаОССрезПоследних.ПервоначальнаяСтоимость КАК Стоимость,
			|	СостоянияОССрезПоследних.Состояние КАК Состояние,
			|	ВЫБОР
			|		КОГДА СправочникОсновныеСредства.Ссылка В (&СписокПодобранных)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК Подобран
			|ИЗ
			|	Справочник.ОсновныеСредства КАК СправочникОсновныеСредства
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыУчетаОС.СрезПоследних(ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0), Организация = &Организация) КАК ПараметрыУчетаОССрезПоследних
			|		ПО СправочникОсновныеСредства.Ссылка = ПараметрыУчетаОССрезПоследних.ОсновноеСредство
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОС.СрезПоследних(ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0), Организация = &Организация) КАК СостоянияОССрезПоследних
			|		ПО СправочникОсновныеСредства.Ссылка = СостоянияОССрезПоследних.ОсновноеСредство
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних КАК МестонахождениеОССрезПоследних
			|		ПО СправочникОсновныеСредства.Ссылка = МестонахождениеОССрезПоследних.ОсновноеСредство
			|ГДЕ
			|	НЕ СправочникОсновныеСредства.ЭтоГруппа
			|	И СостоянияОССрезПоследних.Состояние В(&СостоянияОС)
			|	И МестонахождениеОССрезПоследних.МОЛ = &МОЛ
			|	И МестонахождениеОССрезПоследних.Подразделение = &Подразделение";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "МестонахождениеОССрезПоследних.Подразделение = &Подразделение", "ИСТИНА");		
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.МОЛ) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "МестонахождениеОССрезПоследних.МОЛ = &МОЛ", "ИСТИНА");		
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "МестонахождениеОССрезПоследних.Склад = &Склад", "ИСТИНА");		
	КонецЕсли;	
	
	СписокОС.ТекстЗапроса = ТекстЗапроса;	
КонецПроцедуры // УстановитьТекстЗапросаСписокОС()

&НаСервере
// Процедура устанавливает значения параметров динамических списков 
//
// Значения считываются из реквизитов обработки
//
Процедура УстановитьПараметрыДинамическихСписков()
	
	//Параметры, заполняемые особым образом, например, Организация
	ПараметрОрганизация = Новый ПараметрКомпоновкиДанных("Организация");
	
	МассивСписков = Новый Массив;
	МассивСписков.Добавить(СписокИерархияОС);
	МассивСписков.Добавить(СписокОС);
	
	Для каждого ДинамическийСписок Из МассивСписков Цикл
	
		Для Каждого ПараметрСписка Из ДинамическийСписок.Параметры.Элементы Цикл
			
			ЗначениеРеквизитаОбъекта = Неопределено;
			Если ПараметрСписка.Параметр = ПараметрОрганизация Тогда
				
				ДинамическийСписок.Параметры.УстановитьЗначениеПараметра(ПараметрСписка.Параметр, Объект.Организация);
				
			//ИначеЕсли ПараметрСписка.Параметр = ПараметрОрганизация Тогда
			//	
			//	ДинамическийСписок.Параметры.УстановитьЗначениеПараметра(ПараметрСписка.Параметр, Объект.Организация);
				
			ИначеЕсли Объект.Свойство(ПараметрСписка.Параметр, ЗначениеРеквизитаОбъекта) Тогда
				
				Если ТипЗнч(ЗначениеРеквизитаОбъекта) = Тип("СписокЗначений") Тогда
					
					ЗначениеРеквизитаОбъекта = СписокЗначенийВМассив(ЗначениеРеквизитаОбъекта);					
					
				КонецЕсли;
				
				ДинамическийСписок.Параметры.УстановитьЗначениеПараметра(ПараметрСписка.Параметр, ЗначениеРеквизитаОбъекта);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
КонецПроцедуры // УстановитьПараметрыДинамическихСписков()

&НаКлиенте
// Процедура управляет переключением видов отборов
//
Процедура ПереключитьВидОтбора(ВидОтбора)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, КешНастройкиПодбора.ТекущийВидОтбора, "Пометка", Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ВидОтбора, "Пометка", Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокИерархияОС", "Видимость", ВидОтбора = "ОтборПоПапкамОС");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокИерархияОСПоГруппамИмущества", "Видимость", ВидОтбора = "ОтборПоГруппамИмущества");
	
	КешНастройкиПодбора.ТекущийВидОтбора = ВидОтбора;
	
КонецПроцедуры // ПереключитьВидОтбора()

#КонецОбласти

// Преобразование типов

// Преобразует набор данных с типом СписокЗначений в Массив
// 
Функция СписокЗначенийВМассив(ВхСписокЗначений) Экспорт
	
	МассивДанных = Новый Массив;
	
	Для каждого ЭлементСпискаЗначений Из ВхСписокЗначений Цикл
		
		МассивДанных.Добавить(ЭлементСпискаЗначений.Значение);
		
	КонецЦикла;
	
	Возврат МассивДанных;
	
КонецФункции // СписокЗначенийВМассив()

// Конец Преобразование типов

&НаСервере
// Процедура заполняет данные объекта по переданным параметрам
// вызывается событием ПриЗаписиОбъекта, 
//
Процедура ЗаполнитьДанныеОбъекта()
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
КонецПроцедуры // ЗаполнитьДанныеОбъекта()

&НаСервере
// Процедура заполняет сведения о документе вызвавшем подбор
// вызывается событием ПриЗаписиОбъекта, 
//
Процедура ЗаполнитьСведенияОДокументе(СведенияОДокументе)
	
	Обработки.ПодборОС.СтруктураСведенийОДокументе(СведенияОДокументе);
	ЗаполнитьЗначенияСвойств(СведенияОДокументе, Объект);
	
КонецПроцедуры // ЗаполнитьСведенияОДокументе()

&НаСервере
// Функция помещает результаты подбора в хранилище
//
// Возвращает структуру:
//	Структура
//		- Адрес в хранилище, куда помещена выбранное ОС (корзина);
//		- Уникальный идентификатор формы владельца, необходим для идентификации при обработке результатов подбора;
//
Функция ЗаписатьПодборВХранилище() 
	
	АдресКорзиныВХранилище = ПоместитьВоВременноеХранилище(Объект.Корзина.Выгрузить(), Объект.УникальныйИдентификаторФормыВладельца);
	Возврат Новый Структура("АдресКорзиныВХранилище, УникальныйИдентификаторФормыВладельца", АдресКорзиныВХранилище, Объект.УникальныйИдентификаторФормыВладельца);
	
КонецФункции // ЗаписатьПодборВХранилище()

&НаСервере
// Процедура устанавливает свойства элементов формы
//
Процедура УстановитьСвойстваЭлементовФормы()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаИзменитьВидимостьКорзины", "Пометка", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КорзинаСтоимость", "Доступность", КешНастройкиПодбора.РазрешеноИзменятьСтоимость);
	
КонецПроцедуры // УстановитьСвойстваЭлементовФормы()

&НаКлиенте
// Процедура устанавливает переданный элемент формы текущим
//
Процедура УстановитьТекущийЭлементыФормы(Элемент)
	
	ЭтаФорма.ТекущийЭлемент = Элемент;
	
КонецПроцедуры // УстановитьТекущийЭлементыФормы()

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем СведенияОДокументе;
	
	Обработки.ПодборОС.ПроверитьЗаполнениеПараметров(Параметры, Отказ);
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	ЗаполнитьДанныеОбъекта();
	ЗаполнитьСведенияОДокументе(СведенияОДокументе);
	
	УстановитьТекстЗапросаСписокОС(Параметры.ЭтоДокументПоступления);
	
	ПодключитьПолнотекстовыйПоискПриОткрытииПодбора();
	УстановитьПараметрыДинамическихСписков();
	
	КешНастройкиПодбора = Новый Структура;
	КешНастройкиПодбора.Вставить("ЗапрашиватьСтоимость", Параметры.ЭтоДокументПоступления);
	КешНастройкиПодбора.Вставить("РазрешеноИзменятьСтоимость", Параметры.ЭтоДокументПоступления);
	КешНастройкиПодбора.Вставить("ТекущийПользователь", Пользователи.АвторизованныйПользователь());
	КешНастройкиПодбора.Вставить("СведенияОДокументе", СведенияОДокументе);
	КешНастройкиПодбора.Вставить("ПоискВыполненПриОкончанииРедактирования", Ложь);
	
	КешНастройкиПодбора.Вставить("ТекущийВидОтбора", "ОтборПоПапкамОС");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, КешНастройкиПодбора.ТекущийВидОтбора, "Пометка", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокИерархияОС", "Видимость", КешНастройкиПодбора.ТекущийВидОтбора = "ОтборПоПапкамОС");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокИерархияОСПоГруппамИмущества", "Видимость", КешНастройкиПодбора.ТекущийВидОтбора = "ОтборПоГруппамИмущества");
	
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Процедура - обработчик команды ВыполнитьПоиск
//
Процедура ВыполнитьПоиск(Команда)
	
	Если НЕ КешНастройкиПодбора.ПоискВыполненПриОкончанииРедактирования Тогда
		ВыполнитьПоискИУстановитьОтбор();
	Иначе
		КешНастройкиПодбора.ПоискВыполненПриОкончанииРедактирования = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьПоиск()

&НаКлиенте
// Процедура - обработчик команды ПеренестиВДокумент
//
Процедура ПеренестиВДокумент(Команда)
	
	Закрыть(ЗаписатьПодборВХранилище());
	
КонецПроцедуры // ПеренестиВДокумент()

// Процедура - обработчик команды Выбрать
//
&НаКлиенте
Процедура ДобавитьВКорзину(Команда)
	
	ДобавитьОСВКорзину();
	
КонецПроцедуры // Выбрать()

&НаКлиенте
//Процедура - обработчик команды ПерейтиКРодителю (контекст. меню списка ОС)
//
Процедура ПерейтиКРодителю(Команда)
	
	ДанныеТекущейСтроки = ПолучитьДанныеТекущейСтрокиСписка();
	
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		Элементы.СписокИерархияОС.ТекущаяСтрока = ДанныеТекущейСтроки.Родитель;
	КонецЕсли;
	
КонецПроцедуры // ПерейтиКРодителю()

&НаКлиенте
//Процедура - обработчик команды ИзменитьВидимостьКорзины (меню формы)
//
Процедура ИзменитьВидимостьКорзины(Команда)
	
	Элементы.ФормаИзменитьВидимостьКорзины.Пометка = НЕ Элементы.ФормаИзменитьВидимостьКорзины.Пометка;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КорзинаЦенаОстатокРезервХарактеристика", "Видимость", Элементы.ФормаИзменитьВидимостьКорзины.Пометка);
	
КонецПроцедуры // ИзменитьВидимостьКорзины()

&НаКлиенте
//Процедура - обработчик команды ПереходПолнотектовыйПоиск
Процедура ПереходПолнотектовыйПоиск(Команда)
	
	УстановитьТекущийЭлементыФормы(Элементы.ТекстПоиска);
	
КонецПроцедуры // ПереходПолнотектовыйПоиск()

&НаКлиенте
//Процедура - обработчик команды ПереходИерархия
Процедура ПереходИерархия(Команда)
	
	УстановитьТекущийЭлементыФормы(Элементы.СписокИерархияОС);
	
КонецПроцедуры // ПереходИерархия()

&НаКлиенте
//Процедура - обработчик команды ПереходКорзина
Процедура ПереходКорзина(Команда)
	
	УстановитьТекущийЭлементыФормы(Элементы.Корзина);
	
КонецПроцедуры // ПереходКорзина()

&НаКлиенте
//Процедура - обработчик команды СведенияОДокументе
//
Процедура СведенияОДокументе(Команда)
	
	ОписаниеОповещенияПриЗакрытииПодбора = Новый ОписаниеОповещения("ПослеЗакрытияФормыСведенияОДокументе", ЭтотОбъект);
	ОткрытьФорму("Обработка.ПодборОС.Форма.СведенияОДокументе", 
		КешНастройкиПодбора.СведенияОДокументе, ЭтаФорма, Истина, , ,ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // СведенияОДокументе()

&НаКлиенте
// Процедура - обработчик команды ОтборПоПапкамОС
//
Процедура ОтборПоПапкамОС(Команда)
	
	ПереключитьВидОтбора(Команда.Действие);
	
КонецПроцедуры // ОтборПоПапкамОС()

&НаКлиенте
// Процедура - обработчик команды ОтборПоГруппамИмущества
//
Процедура ОтборПоГруппамИмущества(Команда)
	
	ПереключитьВидОтбора(Команда.Действие);
	
КонецПроцедуры // ОтборПоГруппамИмущества()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
// Процедура - обработчик события ПриАктивизацииСтроки реквизита СписокИерархияОС
//
Процедура СписокИерархияОСПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьОтборПоГруппеДинамическихСписков", 0.2, Истина);
	
КонецПроцедуры // СписокИерархияОСПриАктивизацииСтроки()

&НаКлиенте
// Процедура - обработчик события ПриАктивизацииСтроки реквизита СписокИерархияОС
//
Процедура СписокИерархияОСПоКатегориямПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьОтборПоГруппеДинамическихСписков", 0.2, Истина);
	
КонецПроцедуры // СписокИерархияСписокИерархияОСПоГруппамИмуществаПриАктивизацииСтроки()

&НаКлиенте
// Процедура - обработчик события Выбор реквизита СписокЗапасы
//
Процедура СписокОСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьОСВКорзину();
	
КонецПроцедуры // СписокЗапасыВыбор()

&НаКлиенте
// Процедура - обработчик события ОкончаниеПеретаскивания реквизита СписокЗапасы
//
Процедура СписокОСОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьОСВКорзину();
	
КонецПроцедуры // СписокЗапасыОкончаниеПеретаскивания()

&НаКлиенте
// Процедура - обработчик события ПриИзменении реквизита ТекстПоиска
//
Процедура ТекстПоискаПриИзменении(Элемент)
	
	Если ПустаяСтрока(ТекстПоиска) Тогда
		Если ИспользоватьПолнотекстовыйПоиск Тогда
			РаботаСОтборамиКлиентСервер.УдалитьЭлементОтбораСписка(СписокОС, "ОССсылка");
		Иначе
			КонтекстныйПоискНаКлиенте();
		КонецЕсли;
	Иначе
		ВыполнитьПоискИУстановитьОтбор();
		КешНастройкиПодбора.ПоискВыполненПриОкончанииРедактирования = Истина;
	КонецЕсли;
	
КонецПроцедуры // ТекстПоискаПриИзменении()

&НаКлиенте
// Процедура - обработчик события Очистка реквизита ТекстПоиска
//
Процедура ТекстПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекстПоиска = "";
	Если ИспользоватьПолнотекстовыйПоиск Тогда
		РаботаСОтборамиКлиентСервер.УдалитьЭлементОтбораСписка(СписокОС, "ОССсылка");
	Иначе
		КонтекстныйПоискНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры // ТекстПоискаОчистка()

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
// Процедура обрабатывает результаты открытия дополнительной формы "Количества и Стоимость"
//
//
Процедура ПослеВыбораСтоимости(РезультатЗакрытия, ДанныеСтрокиКорзины) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		Если ДанныеСтрокиКорзины.СтрокаКорзины = Неопределено Тогда
			СтрокаКорзины = Объект.Корзина.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаКорзины, ДанныеСтрокиКорзины);
			СтрокаКорзины.Количество = 1;
			СтрокаКорзины.Стоимость	= РезультатЗакрытия.Стоимость;
		Иначе
			СтрокаКорзины = Объект.Корзина.НайтиПоИдентификатору(ДанныеСтрокиКорзины.СтрокаКорзины);
			СтрокаКорзины.Количество = 1;
			СтрокаКорзины.Стоимость	= РезультатЗакрытия.Стоимость;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПослеВыбораСтоимости()

&НаКлиенте
// Процедура обрабатывает результаты открытия дополнительной формы "Сведения о документе"
//
Процедура ПослеЗакрытияФормыСведенияОДокументе(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ПараметрыОсновнойФормыПодбора = ДополнительныеПараметры;
	
КонецПроцедуры // ПослеЗакрытияФормыСведенияОДокументе()

#КонецОбласти