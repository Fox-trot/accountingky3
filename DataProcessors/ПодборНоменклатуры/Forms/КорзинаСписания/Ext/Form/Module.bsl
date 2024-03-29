﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем СведенияОДокументе;
	
	Обработки.ПодборНоменклатуры.ПроверитьЗаполнениеПараметров(Параметры, Отказ, "КорзинаСписания");
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	ЗаполнитьДанныеОбъекта();
	ЗаполнитьСведенияОДокументе(СведенияОДокументе);
	ЗаполнитьПодобранныеВДокументе();
	
	ПодключитьПолнотекстовыйПоискПриОткрытииПодбора();
	УстановитьПараметрыДинамическихСписков();
	
	КешНастройкиПодбора = Новый Структура;
	КешНастройкиПодбора.Вставить("ЗапрашиватьКоличество", БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ЗапрашиватьКоличество"));
	КешНастройкиПодбора.Вставить("ТекущийПользователь", Пользователи.АвторизованныйПользователь());
	КешНастройкиПодбора.Вставить("СведенияОДокументе", СведенияОДокументе);
	КешНастройкиПодбора.Вставить("ПоискВыполненПриОкончанииРедактирования", Ложь);
	
	КешНастройкиПодбора.Вставить("ТекущийВидОтбора", "ОтборПоГруппам");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, КешНастройкиПодбора.ТекущийВидОтбора, "Пометка", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокИерархияОС", "Видимость", КешНастройкиПодбора.ТекущийВидОтбора = "ОтборПоГруппам");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокИерархияОСПоГруппамИмущества", "Видимость", КешНастройкиПодбора.ТекущийВидОтбора = "ОтборПоГруппамИмущества");
			
	УстановитьСвойстваЭлементовФормы();
	
	Заголовок = СтрШаблон(НСтр("ru = 'Подбор товаров на дату %1 по складу %2'"), Объект.Дата, Объект.Склад);
	ЦветСтиляНедоступныеДанные = ОбщегоНазначенияВызовСервера.ЦветСтиля("НедоступныеДанныеЦвет");
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьСписокПодобранных();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода ТолькоПоложительныеОстатки.
//
&НаКлиенте
Процедура ТолькоПоложительныеОстаткиПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("ТолькоПоложительныеОстатки", Объект.ТолькоПоложительныеОстатки);
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПриАктивизацииСтроки реквизита СписокИерархия
//
Процедура СписокИерархияПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьОтборПоГруппеДинамическихСписков", 0.2, Истина);
	
КонецПроцедуры // СписокИерархияОСПриАктивизацииСтроки()

&НаКлиенте
// Процедура - обработчик события Выбор реквизита СписокЗапасы
//
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьНоменклатуруВКорзину();
	
КонецПроцедуры // СписокЗапасыВыбор()

&НаКлиенте
// Процедура - обработчик события ОкончаниеПеретаскивания реквизита СписокЗапасы
//
Процедура СписокОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьНоменклатуруВКорзину();
	
КонецПроцедуры // СписокЗапасыОкончаниеПеретаскивания()

&НаКлиенте
// Процедура - обработчик события ПриИзменении реквизита ТекстПоиска
//
Процедура ТекстПоискаПриИзменении(Элемент)
	
	Если ПустаяСтрока(ТекстПоиска) Тогда
		Если ИспользоватьПолнотекстовыйПоиск Тогда
			РаботаСОтборамиКлиентСервер.УдалитьЭлементОтбораСписка(Список, "Ссылка");
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
		РаботаСОтборамиКлиентСервер.УдалитьЭлементОтбораСписка(Список, "Ссылка");
	Иначе
		КонтекстныйПоискНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры // ТекстПоискаОчистка()

&НаКлиенте
Процедура КорзинаПослеУдаления(Элемент)
	ОбновитьСписокПодобранных();	
КонецПроцедуры

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
	
	ДобавитьНоменклатуруВКорзину();
	
КонецПроцедуры // Выбрать()

&НаКлиенте
// Процедура - обработчик команды ПерейтиКРодителю (контекст. меню списка ОС)
//
Процедура ПерейтиКРодителю(Команда)
	
	ДанныеТекущейСтроки = ПолучитьДанныеТекущейСтрокиСписка();
	
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		Элементы.СписокИерархияНоменклатура.ТекущаяСтрока = ДанныеТекущейСтроки.Родитель;
	КонецЕсли;
	
КонецПроцедуры // ПерейтиКРодителю()

&НаКлиенте
// Процедура - обработчик команды ПереходПолнотекстовыйПоиск
Процедура ПереходПолнотекстовыйПоиск(Команда)
	
	УстановитьТекущийЭлементыФормы(Элементы.ТекстПоиска);
	
КонецПроцедуры // ПереходПолнотекстовыйПоиск()

&НаКлиенте
// Процедура - обработчик команды ПереходИерархия
Процедура ПереходИерархия(Команда)
	
	УстановитьТекущийЭлементыФормы(Элементы.СписокИерархияНоменклатура);
	
КонецПроцедуры // ПереходИерархия()

&НаКлиенте
// Процедура - обработчик команды ПереходКорзина
Процедура ПереходКорзина(Команда)
	
	УстановитьТекущийЭлементыФормы(Элементы.Корзина);
	
КонецПроцедуры // ПереходКорзина()

&НаКлиенте
// Процедура - обработчик команды СведенияОДокументе
//
Процедура СведенияОДокументе(Команда)
	
	ОписаниеОповещенияПриЗакрытииПодбора = Новый ОписаниеОповещения("ПослеЗакрытияФормыСведенияОДокументе", ЭтотОбъект);
	ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.СведенияОДокументе", 
		КешНастройкиПодбора.СведенияОДокументе, ЭтаФорма, Истина, , ,ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // СведенияОДокументе()

&НаКлиенте
// Процедура - обработчик команды ОтборПоГруппам
//
Процедура ОтборПоГруппам(Команда)
	
	ПереключитьВидОтбора(Команда.Действие);
	
КонецПроцедуры // ОтборПоГруппам()

&НаКлиенте
// Процедура - обработчик команды ИзменитьНастройки
//
Процедура ИзменитьНастройки(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьНастройкиПодбора", ЭтотОбъект);
	ПараметрКорзины = Новый Структура();
	ПараметрКорзины.Вставить("Корзина", "КорзинаСписания");
	ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Настройка", ПараметрКорзины, ЭтаФорма, Истина, , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // ИзменитьНастройки()


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПолнотекстовыйПоиск

&НаСервереБезКонтекста
// Функция заполняет массив ссылок результата поиска или возвращает описание ошибки
//
//
Функция ПолнотекстовыйПоискНаСервереБезКонтекста(СтрокаПоиска, РезультатПоиска)
	
	ОписаниеОшибки = "";
	РезультатПоиска = Поиск(СтрокаПоиска, ОписаниеОшибки);
	
	Возврат ОписаниеОшибки;
	
КонецФункции // ПолнотекстовыйПоискНаСервереБезКонтекста()

&НаСервереБезКонтекста
Функция ПолнотекстовыйПоиск(СтрокаПоиска, РезультатПоиска)
	
	// Поиск данных
	РазмерПорции = 200;
	ОбластьПоиска = Новый Массив;
	ОбластьПоиска.Добавить(Метаданные.Справочники.Номенклатура);
	
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
			
			Если Элемент.Метаданные = Метаданные.Справочники.Номенклатура Тогда
				РезультатПоиска.Номенклатура.Добавить(Элемент.Значение);
			Иначе
				ВызватьИсключение НСтр("ru = 'Неизвестная ошибка'");
			КонецЕсли;
			
		КонецЦикла;
		
		НачальнаяПозиция    = НачальнаяПозиция + РазмерПорции;
		ЕстьСледующаяПорция = (НачальнаяПозиция < КоличествоНайденныхЭлементов - 1);
		
		Если ЕстьСледующаяПорция Тогда
			
			КонечнаяПозиция = ?(КоличествоНайденныхЭлементов > НачальнаяПозиция + РазмерПорции,
			                    РазмерПорции, КоличествоНайденныхЭлементов - НачальнаяПозиция) - 1;
			СписокПоиска.СледующаяЧасть();
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат "ВыполненоУспешно";
	
КонецФункции

&НаСервереБезКонтекста
Функция Поиск(СтрокаПоиска, ОписаниеОшибки) Экспорт
	
	РезультатПоиска = Новый Структура;
	РезультатПоиска.Вставить("Номенклатура", Новый Массив);
	
	Результат = ПолнотекстовыйПоиск(СтрокаПоиска, РезультатПоиска);
	
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
			Использование = РезультатПоиска.Номенклатура.Количество() > 0;
			МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, "Ссылка");
			Если МассивЭлементов.Количество() = 0 Тогда
				
				ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
					"Ссылка", ВидСравненияКомпоновкиДанных.ВСписке, РезультатПоиска.Номенклатура, , Использование);
			Иначе
				ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
					"Ссылка", , РезультатПоиска.Номенклатура, ВидСравненияКомпоновкиДанных.ВСписке, Использование);
			КонецЕсли;
			
			ТекущийЭлемент = Элементы.Список;
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
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Ссылка", ПредставлениеГруппыПолей);
		
	Иначе
		
		МассивОтборов = СформироватьМассивОтбора(ТекстПоиска);
		
		МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, , ПредставлениеГруппыПолей);
		Если МассивЭлементов.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
				"Ссылка", ВидСравненияКомпоновкиДанных.ВСписке, МассивОтборов, ПредставлениеГруппыПолей, Истина);
		Иначе
			ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, 
				"Ссылка", ПредставлениеГруппыПолей, МассивОтборов, ВидСравненияКомпоновкиДанных.ВСписке, Истина);
		КонецЕсли;
		
		ТекущийЭлемент = Элементы.Список;
	КонецЕсли;
	
КонецПроцедуры // КонтекстныйПоискНаКлиенте()

&НаСервереБезКонтекста
Функция СформироватьМассивОтбора(ТекстПоиска)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ Спр.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ПоНаименованию ИЗ Справочник.Номенклатура КАК Спр
	|ГДЕ Спр.Наименование ПОДОБНО &ТекстПоиска;
	|////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ Спр.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ПоПолномуНаименованию ИЗ Справочник.Номенклатура КАК Спр
	|ГДЕ Спр.НаименованиеПолное ПОДОБНО &ТекстПоиска;
	|////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ Спр.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ПоКомментарию ИЗ Справочник.Номенклатура КАК Спр
	|ГДЕ Спр.Комментарий ПОДОБНО &ТекстПоиска;
	|////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПоНаименованию.Ссылка КАК Ссылка
	|ОБЪЕДИНИТЬ
	|ВЫБРАТЬ ПоПолномуНаименованию.Ссылка
	|ОБЪЕДИНИТЬ
	|ВЫБРАТЬ ПоКомментарию.Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТекстПоиска", "%" + ТекстПоиска + "%");
	ВременнаяТаблицаНоменклатуры = Запрос.Выполнить().Выгрузить();
	
	Возврат ВременнаяТаблицаНоменклатуры.ВыгрузитьКолонку("Ссылка");
	
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
			
			Если ОбщегоНазначения.РазделениеВключено()
				И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
				
				// в разделенной ИБ считаем актуальным индекс в пределах 2 дней
				АктуальностьИндексаППД = ПолнотекстовыйПоиск.ДатаАктуальности() >= (ТекущаяДатаСеанса()-(2*24*60*60));
				
			Иначе
				
				// в неразделенной ИБ считаем актуальным индекс в пределах дня
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
	Возврат Элементы.Список.ТекущиеДанные;
КонецФункции // ПолучитьДанныеТекущейСтрокиСписка()

&НаКлиенте
// Функция ищет строки в корзине подбора с указанной ОС
// 	используется перед добавление ОС в корзину.
//
// Возвращает:
//		- Неопределено, если ОС не найдена;
//		- Строку корзины, если ОС найдена;
//
Функция НайтиВКорзине(ДанныеТекущейСтроки)
	
	СтруктураОтбора = Новый Структура("Номенклатура, СчетУчета", ДанныеТекущейСтроки.Ссылка, ДанныеТекущейСтроки.СчетУчета);
	НайденныеСтроки = Объект.Корзина.НайтиСтроки(СтруктураОтбора);
	
	Возврат ?(НайденныеСтроки.Количество() = 0, Неопределено, НайденныеСтроки[0]);
	
КонецФункции // НайтиВКорзине()

&НаКлиенте
// Процедура добавления номенклатуры в корзину подбора
//
Процедура ДобавитьНоменклатуруВКорзину()
	
	ДанныеТекущейСтроки = ПолучитьДанныеТекущейСтрокиСписка();
	
	ДанныеСтрокиКорзины = Новый Структура;
	
	НайденнаяСтрока = НайтиВКорзине(ДанныеТекущейСтроки);
	ДанныеСтрокиКорзины.Вставить("СтрокаКорзины", ?(НайденнаяСтрока <> Неопределено, НайденнаяСтрока.ПолучитьИдентификатор(), НайденнаяСтрока));
	ДанныеСтрокиКорзины.Вставить("Номенклатура", ДанныеТекущейСтроки.Ссылка);
	ДанныеСтрокиКорзины.Вставить("СчетУчета", ДанныеТекущейСтроки.СчетУчета);
	
	Если КешНастройкиПодбора.ЗапрашиватьКоличество Тогда
		
		ДанныеСтрокиКорзины.Вставить("КешНастройкиПодбора",	КешНастройкиПодбора);
		ДанныеСтрокиКорзины.Вставить("Количество",			1);
		ДанныеСтрокиКорзины.Вставить("Номенклатура", 		ДанныеСтрокиКорзины.Номенклатура);		
		ДанныеСтрокиКорзины.Вставить("Корзина", 			"КорзинаСписания");
		
		ОписаниеОповещенияПриЗакрытииПодбора = Новый ОписаниеОповещения("ПослеВыбораКоличества", ЭтотОбъект, ДанныеСтрокиКорзины);
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КоличествоИЦена", 
			ДанныеСтрокиКорзины, ЭтаФорма, Истина, , ,ОписаниеОповещенияПриЗакрытииПодбора , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		Если ДанныеСтрокиКорзины.СтрокаКорзины = Неопределено Тогда
			СтрокаКорзины = Объект.Корзина.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаКорзины, ДанныеСтрокиКорзины);
		Иначе
			СтрокаКорзины = НайденнаяСтрока;
		КонецЕсли;
		
		СтрокаКорзины.Количество = СтрокаКорзины.Количество + 1;
		
		ОбновитьСписокПодобранных();	
	КонецЕсли;
КонецПроцедуры // ДобавитьНоменклатуруВКорзину()

#КонецОбласти

#Область УправлениеСписками

&НаКлиенте
// Процедура обновляет динамические списки Запасы
//
Процедура ОбновитьОтборПоГруппеДинамическихСписков()
	
	Если КешНастройкиПодбора.ТекущийВидОтбора = "ОтборПоГруппам" Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Заявка");
		ИмяДинамическогоСписка = "СписокИерархияНоменклатура";
		ИмяОтбора = "Родитель";
	КонецЕсли;
	
	ДанныеТекущейСтроки = Элементы[ИмяДинамическогоСписка].ТекущиеДанные;
	Если ДанныеТекущейСтроки = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, ИмяОтбора);
	Иначе
		
		МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, ИмяОтбора);
		Если МассивЭлементов.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, ИмяОтбора, ВидСравненияКомпоновкиДанных.ВИерархии, ДанныеТекущейСтроки.Ссылка);
		Иначе
			ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, ИмяОтбора, , ДанныеТекущейСтроки.Ссылка, ВидСравненияКомпоновкиДанных.ВИерархии);
		КонецЕсли;
		
	КонецЕсли;                
	
КонецПроцедуры //ОбновитьОтборПоГруппеДинамическихСписков()

&НаСервере
// Процедура устанавливает значения параметров динамических списков 
//
// Значения считываются из реквизитов обработки
//
Процедура УстановитьПараметрыДинамическихСписков()
	
	МассивСписков = Новый Массив;
	МассивСписков.Добавить(Список);
	
	Для Каждого ДинамическийСписок Из МассивСписков Цикл
		Для Каждого ПараметрСписка Из ДинамическийСписок.Параметры.Элементы Цикл
			ЗначениеРеквизитаОбъекта = Неопределено;
			Если Объект.Свойство(ПараметрСписка.Параметр, ЗначениеРеквизитаОбъекта) Тогда
				Если ТипЗнч(ЗначениеРеквизитаОбъекта) = Тип("СписокЗначений") Тогда
					ЗначениеРеквизитаОбъекта = СписокЗначенийВМассив(ЗначениеРеквизитаОбъекта);					
				КонецЕсли;
				ДинамическийСписок.Параметры.УстановитьЗначениеПараметра(ПараметрСписка.Параметр, ЗначениеРеквизитаОбъекта);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ВидСубконто = Новый Массив;
	ВидСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	Список.Параметры.УстановитьЗначениеПараметра("ВидыСубконто", ВидСубконто);
	
	ВидСубконто = Новый Массив;
	ВидСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Местонахождение);
	Список.Параметры.УстановитьЗначениеПараметра("ВидыСубконтоМБП", ВидСубконто);
	
КонецПроцедуры // УстановитьПараметрыДинамическихСписков()

&НаКлиенте
// Процедура управляет переключением видов отборов
//
Процедура ПереключитьВидОтбора(ВидОтбора)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, КешНастройкиПодбора.ТекущийВидОтбора, "Пометка", Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ВидОтбора, "Пометка", Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокИерархияНоменклатура", "Видимость", ВидОтбора = "ОтборПоГруппам");
	
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
//
Процедура ЗаполнитьДанныеОбъекта()
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
КонецПроцедуры // ЗаполнитьДанныеОбъекта()

&НаСервере
// Процедура заполняет подобанные по переданным параметрам
//
Процедура ЗаполнитьПодобранныеВДокументе()
	АдресПодобранных = Неопределено;
	Если Параметры.Свойство("АдресПодобранных", АдресПодобранных) Тогда 
		ТаблицаПодобранных.Загрузить(ПолучитьИзВременногоХранилища(АдресПодобранных));
	КонецЕсли;
КонецПроцедуры // ЗаполнитьПодобранныеВДокументе()

&НаСервере
// Процедура заполняет сведения о документе вызвавшем подбор
//
Процедура ЗаполнитьСведенияОДокументе(СведенияОДокументе)
	
	Обработки.ПодборНоменклатуры.СтруктураСведенийОДокументе(СведенияОДокументе);
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
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаИерархия", "Доступность", НЕ ЗначениеЗаполнено(Объект.ГруппаНоменклатуры));
	
	// Определение текущей строки
	Если ЗначениеЗаполнено(Объект.ГруппаНоменклатуры) Тогда 
		Элементы.СписокИерархияНоменклатура.ТекущаяСтрока = Объект.ГруппаНоменклатуры;
	КонецЕсли;	
КонецПроцедуры // УстановитьСвойстваЭлементовФормы()

&НаКлиенте
// Процедура устанавливает переданный элемент формы текущим
//
Процедура УстановитьТекущийЭлементыФормы(Элемент)
	
	ТекущийЭлемент = Элемент;
	
КонецПроцедуры // УстановитьТекущийЭлементыФормы()

// Процедура - Обновить список подобранных
//
&НаКлиенте
Процедура ОбновитьСписокПодобранных()
	
	// Оформление подобранных товаров.
	ЭлементыУсловногоОформленияСписка = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы;
	ЭлементыУсловногоОформленияСписка.Очистить();
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.Корзина Цикл 
		ЭлементУсловногоОформления = ЭлементыУсловногоОформленияСписка.Добавить();
		ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Предустановленный";
		ЭлементУсловногоОформления.Представление = "Уже подобран";  
		
		// Цвет
		ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
		ЭлементЦветаОформления.Значение = ЦветСтиляНедоступныеДанные;
		ЭлементЦветаОформления.Использование = Истина;

		// Группа
		ГруппаЭлементовОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаЭлементовОтбораДанных.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		ГруппаЭлементовОтбораДанных.Использование = Истина;
		
		// Отбор по номенклатуре		
		ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = СтрокаТабличнойЧасти.Номенклатура;
		ЭлементОтбораДанных.Использование  = Истина;
		
		// Отбор по счету учета		
		ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СчетУчета");
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = СтрокаТабличнойЧасти.СчетУчета;
		ЭлементОтбораДанных.Использование  = Истина;
	КонецЦикла;
	
	// Подобранные в документе
	Для Каждого СтрокаТабличнойЧасти Из ТаблицаПодобранных Цикл 
		ЭлементУсловногоОформления = ЭлементыУсловногоОформленияСписка.Добавить();
		ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Предустановленный";
		ЭлементУсловногоОформления.Представление = "Уже подобран";  
		
		// Цвет
		ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
		ЭлементЦветаОформления.Значение = ЦветСтиляНедоступныеДанные;
		ЭлементЦветаОформления.Использование = Истина;

		// Группа
		ГруппаЭлементовОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаЭлементовОтбораДанных.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		ГруппаЭлементовОтбораДанных.Использование = Истина;
		
		// Отбор по номенклатуре		
		ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = СтрокаТабличнойЧасти.Номенклатура;
		ЭлементОтбораДанных.Использование  = Истина;
		
		// Отбор по счету учета		
		ЭлементОтбораДанных = ГруппаЭлементовОтбораДанных.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СчетУчета");
		ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = СтрокаТабличнойЧасти.СчетУчета;
		ЭлементОтбораДанных.Использование  = Истина;
	КонецЦикла;
	
КонецПроцедуры // ОбновитьСписокПодобранных()

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
// Процедура обрабатывает результаты открытия дополнительной формы "Настройки"
//
Процедура ОбновитьНастройкиПодбора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		
		Для Каждого ЭлементНастройки Из РезультатЗакрытия Цикл
			
			Если ЭлементНастройки.Значение <> КешНастройкиПодбора[ЭлементНастройки.Ключ] Тогда
				
				КешНастройкиПодбора[ЭлементНастройки.Ключ] = ЭлементНастройки.Значение;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ОбновитьНастройкиПодбора()

&НаКлиенте
// Процедура обрабатывает результаты открытия дополнительной формы "Количества и Цена"
//
Процедура ПослеВыбораКоличества(РезультатЗакрытия, ДанныеСтрокиКорзины) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		Если ДанныеСтрокиКорзины.СтрокаКорзины = Неопределено Тогда
			
			СтрокаКорзины = Объект.Корзина.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаКорзины, ДанныеСтрокиКорзины);
			СтрокаКорзины.Количество = РезультатЗакрытия.Количество;
			
		Иначе			
			СтрокаКорзины = Объект.Корзина.НайтиПоИдентификатору(ДанныеСтрокиКорзины.СтрокаКорзины);
			СтрокаКорзины.Количество = СтрокаКорзины.Количество + РезультатЗакрытия.Количество;
			
		КонецЕсли;
		
		ОбновитьСписокПодобранных();	
	КонецЕсли;
КонецПроцедуры // ПослеВыбораКоличества()

&НаКлиенте
// Процедура обрабатывает результаты открытия дополнительной формы "Сведения о документе"
//
Процедура ПослеЗакрытияФормыСведенияОДокументе(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ПараметрыОсновнойФормыПодбора = ДополнительныеПараметры;
	
КонецПроцедуры // ПослеЗакрытияФормыСведенияОДокументе()

#КонецОбласти