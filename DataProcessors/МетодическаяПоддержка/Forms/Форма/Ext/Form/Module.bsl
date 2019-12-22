﻿// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВывестиКонтекстныеСсылки(Элементы.ИнформационныеСсылки);
	
КонецПроцедуры

&НаСервере
Процедура ВывестиКонтекстныеСсылки(ГруппаФормы) Экспорт
	
	Попытка
		
		ТаблицаИнформационныхСсылок = Обработки.МетодическаяПоддержка.ПолучитьТаблицуИнформационныхСсылокДляВиджета();
		
		Если ТаблицаИнформационныхСсылок.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		
		// Изменение параметров формы
		ГруппаФормы.ОтображатьЗаголовок = Ложь;
		ГруппаФормы.Подсказка   = "";
		ГруппаФормы.Отображение = ОтображениеОбычнойГруппы.Нет;
		ГруппаФормы.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		
		СформироватьГруппыВывода(ТаблицаИнформационныхСсылок, ГруппаФормы);
		
	Исключение
		ИмяСобытия = Обработки.МетодическаяПоддержка.ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьГруппыВывода(ТаблицаСсылок, ГруппаФормы)
	
	КоличествоСсылок = ТаблицаСсылок.Количество();
	
	ИмяЭлементаФормы                            = "ГруппаИнформационныхСсылок";
	РодительскаяГруппа                          = Элементы.Добавить(ИмяЭлементаФормы, Тип("ГруппаФормы"), ГруппаФормы);
	РодительскаяГруппа.Вид                      = ВидГруппыФормы.ОбычнаяГруппа;
	РодительскаяГруппа.ОтображатьЗаголовок      = Ложь;
	РодительскаяГруппа.Группировка              = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	РодительскаяГруппа.Отображение              = ОтображениеОбычнойГруппы.Нет;
	
	Для Итерация = 1 По КоличествоСсылок Цикл 
		
		ИмяСсылки      = ТаблицаСсылок.Получить(Итерация - 1).Наименование;
		Адрес          = ТаблицаСсылок.Получить(Итерация - 1).Адрес;
		
		ЭлементСсылки                          = Элементы.Добавить("ЭлементСсылки" + Строка(Итерация), Тип("ДекорацияФормы"), РодительскаяГруппа);
		ЭлементСсылки.Вид                      = ВидДекорацииФормы.Надпись;
		ЭлементСсылки.Заголовок                = ИмяСсылки;
		ЭлементСсылки.РастягиватьПоГоризонтали = Истина;
		ЭлементСсылки.Высота                   = 1;
		ЭлементСсылки.Гиперссылка              = Истина;
		ЭлементСсылки.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаИнформационнуюСсылку");
		
		ИнформационныеСсылки.Добавить(ЭлементСсылки.Имя, Адрес);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)
	
	Гиперссылка = ИнформационныеСсылки.НайтиПоЗначению(Элемент.Имя);
	
	Если Гиперссылка <> Неопределено Тогда
		
		ПерейтиПоНавигационнойСсылке(Гиперссылка.Представление);
		
	КонецЕсли;
	
КонецПроцедуры
