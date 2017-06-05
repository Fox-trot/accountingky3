﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.КлючНазначенияИспользования = "ЗапускМонитораИзДокумента" Тогда
		ОтборГруппаОС = Параметры.ОсновноеСредство;	
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементов()
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьОтборыСписокОС()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокОС

&НаКлиенте
Процедура СписокОСПриАктивизацииСтроки(Элемент)
	ПолучитьТаблицуРасшифровкиПоСобытиямОС()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасшифровкаПоСобытиямОС

&НаКлиенте
Процедура РасшифровкаПоСобытиямОССобытиеПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ОтборСобытие) Тогда
		ФиксированнаяСтруктура 		= Новый ФиксированнаяСтруктура("Событие", ОтборСобытие);
		Элементы.РасшифровкаПоСобытиямОС.ОтборСтрок = ФиксированнаяСтруктура; 
	Иначе
		ФиксированнаяСтруктура 		= Новый ФиксированнаяСтруктура();
		Элементы.РасшифровкаПоСобытиямОС.ОтборСтрок = ФиксированнаяСтруктура;		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерепровестиДокументы(Команда)
	ПоказатьРезультатПерепроведения = Истина;
	УстановитьВидимостьДоступностьЭлементов();
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("МассивСсылок", ПолучитьМассивСсылокДляПерепроведения());
	РезультатВыполнения = ПерепровестиДокументыНаСервере(ПараметрыКоманды);
	ПараметрыОбработчикаОжидания = Новый Структура();
	
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьТаблицуРасшифровкаПоСобытиямОС(Команда)
	ПоказатьРезультатПерепроведения = Ложь;
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверку(Команда)
	ВыполнитьПроверкуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
		
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = "*.doc;*.xls;*.*";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";

	Если ДиалогОткрытияФайла.Выбрать() Тогда	
		ЗагрузитьНаСервере(ДиалогОткрытияФайла.ПолноеИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Сравнить(Команда)
	СравнитьНаСервере(Месяц)
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура устанавливает видимость и доступность элементов.
//
Процедура УстановитьВидимостьДоступностьЭлементов()	
	
	Элементы.ПерепровестиДокументы.Видимость 		= НЕ ПоказатьРезультатПерепроведения;
	Элементы.ОтборСобытие.Видимость 				= НЕ ПоказатьРезультатПерепроведения;
	Элементы.РасшифровкаПоСобытиямОС.Видимость		= НЕ ПоказатьРезультатПерепроведения;
	
	Элементы.Результат.Видимость					= ПоказатьРезультатПерепроведения;
	Элементы.СостояниеПрогресса.Видимость			= ПоказатьРезультатПерепроведения;
	Элементы.ПоказатьТаблицуРасшифровкаПоСобытиямОС.Видимость		= ПоказатьРезультатПерепроведения;
	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()    

&НаКлиенте
Процедура ПолучитьТаблицуРасшифровкиПоСобытиямОС()

	ТекущаяСтрока = Элементы.СписокОС.ТекущиеДанные;
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		ПолучитьТаблицуРасшифровкиПоСобытиямОСНаСервере(ТекущаяСтрока.ОсновноеСредство);
	КонецЕсли;
			
КонецПроцедуры // УстановитьОтборРасшифровкаПоСобытиямОС()

&НаСервере
Процедура ПолучитьТаблицуРасшифровкиПоСобытиямОСНаСервере(ОсновноеСредство)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СобытияОС.Организация,
		|	СобытияОС.Период КАК ДатаСобытия,
		|	СобытияОС.Событие,
		|	СобытияОС.ОсновноеСредство КАК ОсновноеСредство,
		|	СобытияОС.Регистратор
		|ПОМЕСТИТЬ ВременнаяТаблицаСобытияИДаты
		|ИЗ
		|	РегистрСведений.СобытияОС КАК СобытияОС
		|ГДЕ
		|	СобытияОС.ОсновноеСредство = &ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаСобытияИДаты.Организация,
		|	ВременнаяТаблицаСобытияИДаты.Событие,
		|	ВременнаяТаблицаСобытияИДаты.ОсновноеСредство,
		|	ВременнаяТаблицаСобытияИДаты.ДатаСобытия,
		|	МАКСИМУМ(МестонахождениеОС.Период) КАК ДатаМестонахождения
		|ПОМЕСТИТЬ ВременнаяТаблицаДатаМестонахождения
		|ИЗ
		|	ВременнаяТаблицаСобытияИДаты КАК ВременнаяТаблицаСобытияИДаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС КАК МестонахождениеОС
		|		ПО ВременнаяТаблицаСобытияИДаты.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство
		|			И ВременнаяТаблицаСобытияИДаты.ДатаСобытия >= МестонахождениеОС.Период
		|ГДЕ
		|	ВременнаяТаблицаСобытияИДаты.ОсновноеСредство = &ОсновноеСредство
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаСобытияИДаты.ДатаСобытия,
		|	ВременнаяТаблицаСобытияИДаты.Организация,
		|	ВременнаяТаблицаСобытияИДаты.Событие,
		|	ВременнаяТаблицаСобытияИДаты.ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаСобытияИДаты.Организация,
		|	ВременнаяТаблицаСобытияИДаты.Событие,
		|	ВременнаяТаблицаСобытияИДаты.ОсновноеСредство КАК ОсновноеСредство,
		|	ВременнаяТаблицаСобытияИДаты.ДатаСобытия,
		|	МАКСИМУМ(ПараметрыУчетаОС.Период) КАК ДатаПараметрыУчета,
		|	ПараметрыУчетаОС.СчетУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаДатаПараметрыУчетаОС
		|ИЗ
		|	ВременнаяТаблицаСобытияИДаты КАК ВременнаяТаблицаСобытияИДаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыУчетаОС КАК ПараметрыУчетаОС
		|		ПО ВременнаяТаблицаСобытияИДаты.ОсновноеСредство = ПараметрыУчетаОС.ОсновноеСредство
		|			И ВременнаяТаблицаСобытияИДаты.ДатаСобытия >= ПараметрыУчетаОС.Период
		|ГДЕ
		|	ВременнаяТаблицаСобытияИДаты.ОсновноеСредство = &ОсновноеСредство
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаСобытияИДаты.ДатаСобытия,
		|	ВременнаяТаблицаСобытияИДаты.Организация,
		|	ВременнаяТаблицаСобытияИДаты.Событие,
		|	ВременнаяТаблицаСобытияИДаты.ОсновноеСредство,
		|	ПараметрыУчетаОС.СчетУчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаСобытияИДаты.Организация,
		|	ВременнаяТаблицаСобытияИДаты.Событие,
		|	ВременнаяТаблицаСобытияИДаты.ОсновноеСредство,
		|	ПараметрыУчетаОС.СчетУчета,
		|	ПараметрыУчетаОС.ПервоначальнаяСтоимость,
		|	МестонахождениеОС.Подразделение,
		|	СУММА(ХозрасчетныйОборотыДтКт.СуммаОборот) КАК НакопленныйИзнос,
		|	ПараметрыУчетаОС.СчетУчета.ПарныйСчет КАК СчетНачисленияАмортизации,
		|	ПараметрыУчетаОС.СрокСлужбы,
		|	ПараметрыУчетаОС.СпособНачисленияАмортизации,
		|	ПараметрыУчетаОС.СпособОтраженияРасходовПоАмортизации,
		|	ВременнаяТаблицаСобытияИДаты.ДатаСобытия,
		|	ВременнаяТаблицаСобытияИДаты.Регистратор КАК Документ
		|ИЗ
		|	ВременнаяТаблицаСобытияИДаты КАК ВременнаяТаблицаСобытияИДаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаДатаМестонахождения КАК ВременнаяТаблицаДатаМестонахождения
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС КАК МестонахождениеОС
		|			ПО ВременнаяТаблицаДатаМестонахождения.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство
		|				И ВременнаяТаблицаДатаМестонахождения.ДатаМестонахождения = МестонахождениеОС.Период
		|		ПО ВременнаяТаблицаСобытияИДаты.ДатаСобытия = ВременнаяТаблицаДатаМестонахождения.ДатаСобытия
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаДатаПараметрыУчетаОС КАК ВременнаяТаблицаДатаПараметрыУчетаОС
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыУчетаОС КАК ПараметрыУчетаОС
		|			ПО ВременнаяТаблицаДатаПараметрыУчетаОС.ОсновноеСредство = ПараметрыУчетаОС.ОсновноеСредство
		|				И ВременнаяТаблицаДатаПараметрыУчетаОС.ДатаПараметрыУчета = ПараметрыУчетаОС.Период
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(, , Авто, , , , ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства), СубконтоКт1 = &ОсновноеСредство) КАК ХозрасчетныйОборотыДтКт
		|			ПО ВременнаяТаблицаДатаПараметрыУчетаОС.СчетУчета.ПарныйСчет = ХозрасчетныйОборотыДтКт.СчетКт
		|				И ВременнаяТаблицаДатаПараметрыУчетаОС.ОсновноеСредство = ХозрасчетныйОборотыДтКт.СубконтоКт1
		|				И ВременнаяТаблицаДатаПараметрыУчетаОС.ДатаСобытия >= ХозрасчетныйОборотыДтКт.ПериодСекунда
		|		ПО ВременнаяТаблицаСобытияИДаты.ДатаСобытия = ВременнаяТаблицаДатаПараметрыУчетаОС.ДатаСобытия
		|ГДЕ
		|	ВременнаяТаблицаСобытияИДаты.ОсновноеСредство = &ОсновноеСредство
		|
		|СГРУППИРОВАТЬ ПО
		|	МестонахождениеОС.Подразделение,
		|	ПараметрыУчетаОС.СпособОтраженияРасходовПоАмортизации,
		|	ВременнаяТаблицаСобытияИДаты.Событие,
		|	ВременнаяТаблицаСобытияИДаты.Организация,
		|	ПараметрыУчетаОС.СпособНачисленияАмортизации,
		|	ВременнаяТаблицаСобытияИДаты.ОсновноеСредство,
		|	ПараметрыУчетаОС.СчетУчета.ПарныйСчет,
		|	ПараметрыУчетаОС.СрокСлужбы,
		|	ПараметрыУчетаОС.ПервоначальнаяСтоимость,
		|	ВременнаяТаблицаСобытияИДаты.ДатаСобытия,
		|	ПараметрыУчетаОС.СчетУчета,
		|	ВременнаяТаблицаСобытияИДаты.Регистратор
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВременнаяТаблицаСобытияИДаты.ДатаСобытия";		
		
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	РасшифровкаПоСобытиямОС.Очистить();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = РасшифровкаПоСобытиямОС.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка)
	КонецЦикла;
	
КонецПроцедуры // ПолучитьТаблицуРасшифровкиПоСобытиямОСНаСервере(ОсновноеСредство)()

&НаКлиенте
Процедура УстановитьОтборыСписокОС()
	СписокОС.Отбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ОтборГруппаОС) Тогда
		ЭлементОтбора = СписокОС.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОсновноеСредство");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = ОтборГруппаОС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборГруппаНУ) Тогда
		ЭлементОтбора = СписокОС.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГруппаНУ");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = ОтборГруппаНУ;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборГруппаИмущества) Тогда
		ЭлементОтбора = СписокОС.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГруппаИмущества");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = ОтборГруппаИмущества;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборСчетБУ) Тогда
		ЭлементОтбора = СписокОС.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СчетУчета");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = ОтборСчетБУ;
	КонецЕсли;

	Если ЗначениеЗаполнено(ОтборПодразделение) Тогда
		ЭлементОтбора = СписокОС.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = ОтборПодразделение;
	КонецЕсли;

	Если ЗначениеЗаполнено(ОтборМОЛ) Тогда
		ЭлементОтбора = СписокОС.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МОЛ");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = ОтборМОЛ;
	КонецЕсли;

	Если ЗначениеЗаполнено(ОтборСостояние) Тогда
		ЭлементОтбора = СписокОС.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Состояние");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = ОтборСостояние;
	КонецЕсли;
		
	ПолучитьТаблицуРасшифровкиПоСобытиямОС()
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроверкуНаСервере()

	СписокПроверки.Очистить();
	ПроверкиПоОС();
	
	Если СписокПроверки.Количество() = 0 Тогда
	
		ТекстСообщения = НСтр("ru = 'Все проверки завершены успешно! Нет данных для заполнения.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "")
	
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПроверкиПоОС()
	
	// Проверка ОС.
	//
	// 1. Наличие у счетов учета субконто "ОсновныеСредства"

	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	ПараметрыУчетаОС.СчетУчета КАК СчетУчета,
	//	|	ХозрасчетныйВидыСубконто.ВидСубконто
	//	|ИЗ
	//	|	РегистрСведений.ПараметрыУчетаОС КАК ПараметрыУчетаОС
	//	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	//	|		ПО ПараметрыУчетаОС.СчетУчета = ХозрасчетныйВидыСубконто.Ссылка
	//	|
	//	|СГРУППИРОВАТЬ ПО
	//	|	ПараметрыУчетаОС.СчетУчета,
	//	|	ХозрасчетныйВидыСубконто.ВидСубконто
	//	|ИТОГИ ПО
	//	|	СчетУчета";
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//
	//ВыборкаСчетОС = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	//МассивСчетовОС = Новый Массив;
	//
	//Пока ВыборкаСчетОС.Следующий() Цикл
	//	ВыборкаСубконтоСчета= ВыборкаСчетОС.Выбрать();
	//	ЕстьСубконтоОС = Ложь;
	//	Пока ВыборкаСубконтоСчета.Следующий() Цикл
	//		Если ВыборкаСубконтоСчета.ВидСубконто = ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства") Тогда			
	//			ЕстьСубконтоОС = Истина;
	//			МассивСчетовОС.Добавить(ВыборкаСчетОС.СчетУчета);
	//            Прервать;			
	//		КонецЕсли;
	//	КонецЦикла;
	//	Если НЕ ЕстьСубконтоОС Тогда
	//		НоваяСтрока = СписокПроверки.Добавить();
	//		НоваяСтрока.ОсновноеСредство = ВыборкаСчетОС.СчетУчета;
	//	    НоваяСтрока.Примечание = "У счета " + ВыборкаСчетОС.СчетУчета + " нет субконто ""ОсновныеСредства""";
	//		
	//	КонецЕсли;

	//КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПараметрыУчетаОС.СчетУчета КАК СчетУчета,
		|	ХозрасчетныйВидыСубконто.ВидСубконто
		|ИЗ
		|	РегистрСведений.ПараметрыУчетаОС КАК ПараметрыУчетаОС
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
		|		ПО ПараметрыУчетаОС.СчетУчета = ХозрасчетныйВидыСубконто.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПараметрыУчетаОС.СчетУчета,
		|	ХозрасчетныйВидыСубконто.ВидСубконто
		|ИТОГИ ПО
		|	СчетУчета";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаСчетОС = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	МассивСчетовОС = Новый Массив;
	МассивСчетовБезСубконтоОС = Новый Массив; 
	
	Пока ВыборкаСчетОС.Следующий() Цикл
		ВыборкаСубконтоСчета= ВыборкаСчетОС.Выбрать();
		ЕстьСубконтоОС = Ложь;
		Пока ВыборкаСубконтоСчета.Следующий() Цикл
			Если ВыборкаСубконтоСчета.ВидСубконто = ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства") Тогда			
				ЕстьСубконтоОС = Истина;
				МассивСчетовОС.Добавить(ВыборкаСчетОС.СчетУчета);
	            Прервать;			
			КонецЕсли;
		КонецЦикла;
		Если НЕ ЕстьСубконтоОС Тогда
			МассивСчетовБезСубконтоОС.Добавить(ВыборкаСчетОС.СчетУчета);			
		КонецЕсли;

	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПараметрыУчетаОС.Регистратор КАК Документ,
		|	ПараметрыУчетаОС.СчетУчета КАК СчетУчета,
		|	ПараметрыУчетаОС.ОсновноеСредство КАК ОсновноеСредство,
		|	ПараметрыУчетаОС.Период КАК Дата,
		|	ПараметрыУчетаОС.ПервоначальнаяСтоимость
		|ИЗ
		|	РегистрСведений.ПараметрыУчетаОС КАК ПараметрыУчетаОС
		|ГДЕ
		|	ПараметрыУчетаОС.СчетУчета В(&МассивСчетовБезСубконтоОС)
		|
		|УПОРЯДОЧИТЬ ПО
		|	СчетУчета,
		|	Дата,
		|	Документ,
		|	ОсновноеСредство";
			
	Запрос.УстановитьПараметр("МассивСчетовБезСубконтоОС", МассивСчетовБезСубконтоОС);	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НоваяСтрока = СписокПроверки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
		НоваяСтрока.Примечание = "У счета " + ВыборкаДетальныеЗаписи.СчетУчета + " нет субконто ""ОсновныеСредства""";
	КонецЦикла;	
	
	// Проверка ОС.
	//
	// 2. Заполненность субконто "ОсновныеСредства" в РБ Хозрасчетный
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХозрасчетныйОбороты.Регистратор КАК Документ,
		|	ХозрасчетныйОбороты.Счет,
		|	ХозрасчетныйОбороты.НомерСтроки
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(, , Авто, Счет В (&МассивСчетовОС), ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства), , , ) КАК ХозрасчетныйОбороты
		|ГДЕ
		|	ХозрасчетныйОбороты.Субконто1 = ЗНАЧЕНИЕ(Справочник.ОсновныеСредства.ПустаяСсылка)";
	
	Запрос.УстановитьПараметр("МассивСчетовОС", МассивСчетовОС);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НоваяСтрока = СписокПроверки.Добавить();
		НоваяСтрока.Документ = ВыборкаДетальныеЗаписи.Документ;
	    НоваяСтрока.Примечание = "В строке №" + ВыборкаДетальныеЗаписи.НомерСтроки + " движений по рег.бухг. не заполнено субконто ОС";
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНаСервере(ПолноеИмяФайла)
	
		Эксель = Новый COMОбъект("Excel.Application");
		ВыбранныйФайл = Новый Файл(ПолноеИмяФАйла);
		Книга = Эксель.WorkBooks.Open(ВыбранныйФайл.ПолноеИмя);
		
		Лист = Книга.WorkSheets(1);
		ВсегоКолонок 	= Лист.UsedRange.Columns.Count;
		ВсегоСтрок 		= Лист.UsedRange.Rows.Count;
		
		ТемаТек = "";
		СджТек  = "";
		Для Строка = 1 по ВсегоСтрок цикл
			
			ИнвНомер		= Лист.Cells(Строка, 1).Value; 			
			Наименование	= Лист.Cells(Строка, 2).Value; 			
			ПС				= Лист.Cells(Строка, 3).Value; 			
			НИ				= Лист.Cells(Строка, 4).Value; 			
			ИЗносЗаМесяц	= Лист.Cells(Строка, 5).Value; 			
			
			СТЧ = Объект.ТаблицаЗагрузки.Добавить();
			СТЧ.ИнвНомер 		= ИнвНомер;
			СТЧ.Наименование 	= Наименование;
			СТЧ.ПС 				= ПС;
			СТЧ.НИ				= НИ;
			СТЧ.ИзносЗаМесяц 	= ИзносЗаМесяц;
			
		КонецЦикла;
		
		Эксель.Application.Quit();  


КонецПроцедуры

&НаСервере
Процедура СравнитьНаСервере(Месяц)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗакрытиеМесяцаАмортизацияОС.ОсновноеСредство,
	|	ЗакрытиеМесяцаАмортизацияОС.ИнвентарныйНомер КАК ИнвНомер,
	|	ЗакрытиеМесяцаАмортизацияОС.Сумма
	|ИЗ
	|	Документ.ЗакрытиеМесяца.АмортизацияОС КАК ЗакрытиеМесяцаАмортизацияОС
	|ГДЕ
	|	ЗакрытиеМесяцаАмортизацияОС.Ссылка.Дата = &Месяц";
	
	Запрос.УстановитьПараметр("Месяц", КонецМесяца(Месяц));
	РезультатЗапроса = Запрос.Выполнить();
	ТЗИзнос = РезультатЗапроса.Выгрузить();
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТЗИзнос.ИнвНомер,
	|	ТЗИзнос.Сумма
	|ПОМЕСТИТЬ ВременнаяТаблицаИзнос
	|ИЗ
	|	&ТЗИзнос КАК ТЗИзнос
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЧ.Наименование,
	|	ТЧ.ИнвНомер,
	|	ТЧ.ПС,
	|	ТЧ.НИ,
	|	ТЧ.ИзносЗаМесяц
	|ПОМЕСТИТЬ ВременнаяТаблицаСостав
	|ИЗ
	|	&ТЧСоотв КАК ТЧ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаСостав.Наименование,
	|	ВременнаяТаблицаСостав.ИнвНомер КАК ИнвНомер,
	|	ВременнаяТаблицаИзнос.Сумма КАК ИзносЗаМесяцБД,
	|	ВременнаяТаблицаСостав.ПС,
	|	ВременнаяТаблицаСостав.НИ,
	|	ВременнаяТаблицаСостав.ИзносЗаМесяц
	|ИЗ
	|	ВременнаяТаблицаСостав КАК ВременнаяТаблицаСостав
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаИзнос КАК ВременнаяТаблицаИзнос
	|		ПО ВременнаяТаблицаСостав.ИнвНомер = ВременнаяТаблицаИзнос.ИнвНомер
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИнвНомер";
	
	Запрос.УстановитьПараметр("ТЧСоотв", Объект.ТаблицаЗагрузки.Выгрузить());
	Запрос.УстановитьПараметр("ТЗИзнос", ТЗИзнос);
	ТЗСоотв = Запрос.Выполнить().Выгрузить();
	
	Объект.ТаблицаЗагрузки.Загрузить(ТЗСоотв);

	
	Для Каждого СТЧ Из Объект.ТаблицаЗагрузки Цикл 
		СТЧ.ОтклИМ = СТЧ.ИзносЗаМесяц - СТЧ.ИзносЗаМесяцБД;	
	КонецЦикла;
	
	
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОтборов

&НаКлиенте
Процедура ОтборГруппаОСПриИзменении(Элемент)
	УстановитьОтборыСписокОС()
КонецПроцедуры

&НаКлиенте
Процедура ОтборГруппаНУПриИзменении(Элемент)
	УстановитьОтборыСписокОС()	
КонецПроцедуры

&НаКлиенте
Процедура ОтборГруппаИмуществаПриИзменении(Элемент)
	УстановитьОтборыСписокОС()
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетБУПриИзменении(Элемент)
	УстановитьОтборыСписокОС()
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	УстановитьОтборыСписокОС()
КонецПроцедуры

&НаКлиенте
Процедура ОтборМОЛПриИзменении(Элемент)
	УстановитьОтборыСписокОС()
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	УстановитьОтборыСписокОС()
КонецПроцедуры

&НаКлиенте
Процедура ОтборСобытиеОчистка(Элемент, СтандартнаяОбработка)
	ФиксированнаяСтруктура 		= Новый ФиксированнаяСтруктура();
	Элементы.РасшифровкаПоСобытиямОС.ОтборСтрок = ФиксированнаяСтруктура; 
КонецПроцедуры

#КонецОбласти

#Область ФоновоеЗаданиеПерепровестиДокументы

&НаСервере
Функция ПолучитьМассивСсылокДляПерепроведения()

	РасшифровкаПоСобытиямОС.Сортировать("ДатаСобытия Возр");
	МассивСсылок = Новый Массив;
	Для каждого СтрокаТаблицы Из РасшифровкаПоСобытиямОС Цикл
		МассивСсылок.Добавить(СтрокаТаблицы.Документ);
	КонецЦикла;

	Возврат МассивСсылок;	

КонецФункции // ()

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЭтаФорма.СостояниеПрогресса = 100;
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДанныеПрогресса = ПолучитьИзВременногоХранилища(АдресХранилищаПрогресса);
			ЭтаФорма.СостояниеПрогресса = ДанныеПрогресса;
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;	
КонецПроцедуры

&НаСервере
Функция ПерепровестиДокументыНаСервере(ПараметрыКоманды)
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	АдресРасшифровки = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	АдресХранилищаПрогресса = ПоместитьВоВременноеХранилище(, УникальныйИдентификатор);
	ПараметрыКоманды.Вставить("АдресРасшифровки", АдресРасшифровки);
	ПараметрыКоманды.Вставить("АдресХранилищаПрогресса", АдресХранилищаПрогресса);
	
	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Обработки.МониторОС.ПерепровестиДокументы",
		ПараметрыКоманды,
		СтрШаблон(НСтр("ru = 'Перепроведение документов: %1'"), ЭтаФорма.Заголовок));
	
	АдресХранилища       = РезультатВыполнения.АдресХранилища;
	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	
	ИдентификаторЗадания = Неопределено;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
КонецФункции

#КонецОбласти

